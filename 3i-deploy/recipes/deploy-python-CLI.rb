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
  end

end

