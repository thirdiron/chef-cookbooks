# beats me what recipe this references.  Maybe it will automatically
# dereferences correctly on opsworks like the opsworks recipes do?
include_recipe 'deploy'

node[:deploy].each do |application, deploy|
#  if deploy[:application_type] != 'nodejs'
#    Chef::Log.debug("Skipping deploy::nodejs for application #{application} as it is not a node.js app")
#    next
#  end

  
  # use the opsworks cookbook to set up
  # deployment directory just like the
  # default cookbook
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  
  # Use the opsworks cookbook to fetch code,
  # npm install, perform backups, set up
  # log rotation etc. just like the 
  # default cookbook
  opsworks_deploy do
    deploy_data deploy
    app application
  end

  ti_opsworks_nodejs do
    deploy_data deploy
    app application
  end

  application_environment_file do
    user deploy[:user]
    group deploy[:group]
    path ::File.join(deploy[:deploy_to], "shared")
    environment_variables deploy[:environment_variables]
  end

  # This seems to only log things instead of actually restart anything
  ruby_block "restart node.js application #{application}" do
    block do
      Chef::Log.info("restart node.js via: #{node[:deploy][application][:nodejs][:restart_command]}")
      Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
      $? == 0
    end
  end
end

