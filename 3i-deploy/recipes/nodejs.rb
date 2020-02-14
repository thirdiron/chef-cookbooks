# beats me what recipe this references.  Maybe it will automatically
# dereferences correctly on opsworks like the opsworks recipes do?
include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs' && deploy['environment_variables']['OPSWORKS_APPLICATION_TYPE'] != 'nodejs-web'
    Chef::Log.debug("Skipping deploy::nodejs for application #{application} as it is not a node.js app")
    next
  end

  if !(node['opsworks']['instance']['layers'].include? deploy[:environment_variables]['OPSWORKS_TARGET_LAYER'])
    Chef::Log.debug("Skipping deploy::nodejs for application #{application} as this instance is not in its target layer")
    next
  end

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
  ti_opsworks_deploy do
    deploy_data deploy
    app application
  end

  service 'rsyslog' do
    :nothing
  end

  template "/etc/rsyslog.d/70-#{application}.conf" do
    source '70-opsworks-monit-app-rsyslog.conf.erb'
    cookbook '3i-deploy'
    owner 'root'
    group 'root'
    variables(
      :application_name => application,
      :deploy => deploy,
      :logentries_token => deploy[:environment_variables]['LOGENTRIES_TOKEN']
    )
    notifies :restart, "service[rsyslog]", :immediately
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

  #ensure syslog user has access to the group that owns the log files
  execute 'add_user_to_group' do
    command 'usermod -a -G www-data syslog'
    user 'root'
  end


  # Also make sure a crontab is in place to delete old deployment folders of this application
  template "/etc/cron.d/#{application}_cleanup_old_releases_crontab" do
    source 'cleanup_old_releases_crontab.erb'
    variables({
      :releases_folder_path => File.join(deploy[:deploy_to], 'releases')
    })
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

