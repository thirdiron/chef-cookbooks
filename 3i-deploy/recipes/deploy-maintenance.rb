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

  opsworks_deploy do
    deploy_data deploy.merge({ :application_type => 'nodejs' })
    app application
  end

  ti_opsworks_pm2_nodejs do
    deploy_data deploy
    app application
  end

  execute 'start_or_restart_cronjs' do
    command "pm2 startOrRestart #{deploy[:deploy_to]}/current/pm2-app.json"
  end

end
