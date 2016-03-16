# beats me what recipe this references.  Maybe it will automatically
# deference correctly on opsworks like the opsworks recipes do?
include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs for application #{application} as it is not a node.js app")
    next
  end

  
  # use the opsworks cookbook to set up
  # deployment directory just like the
  # default cookbook
  deploy::opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  
  # Use the opsworks cookbook to fetch code,
  # npm install, perform backups, set up
  # log rotation etc. just like the 
  # default cookbook
  deploy::opsworks_deploy do
    deploy_data deploy
    app application
  end

  opsworks_nodejs do
    deploy_data deploy
    app application
  end

end

