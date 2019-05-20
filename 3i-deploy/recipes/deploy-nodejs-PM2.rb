include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  # This recipe is for opsworks applications
  # of type 'other' that declare their
  # OPSWORKS_APPLICATION_TYPE in their
  # environment variables as "nodejs-PM2"
  if deploy[:application_type] != 'other' || deploy['environment_variables']['OPSWORKS_APPLICATION_TYPE'] != 'nodejs-PM2'
    Chef::Log.debug("Skipping 3i-deploy::deploy-maintenance for application #{application} as it is not a PM2 app")
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

  ti_opsworks_pm2_nodejs do
    deploy_data deploy
    app application
  end

  service 'rsyslog' do
    :nothing
  end

  template "/etc/rsyslog.d/70-#{application}.conf" do
    source '70-pm2-app-rsyslog.conf.erb'
    cookbook '3i-deploy'
    owner 'root'
    group 'root'
    variables(
      :application_name => application,
      :logentries_token => deploy[:environment_variables]['LOGENTRIES_TOKEN']
    )
    notifies :restart, "service[rsyslog]", :immediately
  end

  execute 'remove_old_process_if_exists' do
    command "env HOME=`eval echo \"~ubuntu\"` pm2 delete #{application} || true"
    user 'ubuntu'
  end

  execute 'build' do
    command "cd #{deploy[:deploy_to]}/current && npm run build"
    only_if { deploy['environment_variables']['REQUIRES_BUILD'] == 'true' }
    user 'root'
  end

  execute 'start_or_restart_cronjs' do
    command "env HOME=`eval echo \"~ubuntu\"` pm2 startOrRestart #{deploy[:deploy_to]}/current/pm2-app.json"
    not_if { deploy['environment_variables']['DISABLED'] == "true" }
    user 'ubuntu'
  end

  # Also make sure a crontab is in place to delete old deployment folders of this application
  template "/etc/cron.d/#{application}_cleanup_old_releases_crontab" do
    source 'cleanup_old_releases_crontab.erb'
    variables({
      :releases_folder_path => File.join(deploy[:deploy_to], 'releases')
    })
  end


end
