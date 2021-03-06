include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  # This recipe is for opsworks applications
  # of type 'other' that declare their
  # OPSWORKS_APPLICATION_TYPE in their
  # environment variables as "python-CLI"
  # 
  # It is intended for applications that expose 
  # their functionality as a CLI available from
  # the PATH for the ubuntu user on the machine
  if deploy[:application_type] != 'other' || deploy['environment_variables']['OPSWORKS_APPLICATION_TYPE'] != 'python-CLI'
    Chef::Log.debug("Skipping 3i-deploy::deploy-python-CLI for application #{application} as it is not a CLI app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  ti_opsworks_deploy do
    deploy_data deploy
    app application
  end

  application_environment_file do
    user deploy[:user]
    group deploy[:group]
    path ::File.join(deploy[:deploy_to], "shared")
    environment_variables deploy[:environment_variables]
  end

  template "/home/ubuntu/profile.d/#{application}_profile" do
    source 'cli-.bash_profile.erb'
    owner 'ubuntu'
    group 'ubuntu'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application
    )
  end

  execute 'run setup script' do
    cwd ::File.join(deploy[:deploy_to], "current")
    command "#{deploy[:deploy_to]}/current/setup.sh"
    only_if "[ -f #{deploy[:deploy_to]}/current/setup.sh ]"
    user 'deploy'
  end

  # Allow an application to provide a crontab.  
  # If present copy it into place in /etc/cron.d
  # using the application's name to generate the name
  # for the crontab

  # First remove any crontab from previous deploys
  file "/etc/cron.d/#{application}_crontab" do
    action :delete
  end

  # Then copy in place a crontab from the repo if one was provided
  execute 'setup crontab' do
    command <<-COMMANDS
      cp #{deploy[:deploy_to]}/current/crontab /etc/cron.d/#{application}_crontab;
      chown root:root /etc/cron.d/#{application}_crontab;
    COMMANDS
    only_if "[ -f #{deploy[:deploy_to]}/current/crontab ]"
    user 'root'
  end

  # Also make sure a crontab is in place to delete old deployment folders of this application
  template "/etc/cron.d/#{application}_cleanup_old_releases_crontab" do
    source 'cleanup_old_releases_crontab.erb'
    variables({
      :releases_folder_path => File.join(deploy[:deploy_to], 'releases')
    })
  end


end

