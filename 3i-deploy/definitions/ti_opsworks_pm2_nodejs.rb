define :ti_opsworks_pm2_nodejs do
  deploy = params[:deploy_data]
  application = params[:app]

  # Use the OpsWorks nodeJS configuration library to
  # invoke npm install
  OpsWorks::NodejsConfiguration.npm_install(application, node[:deploy][application], release_path, node[:opsworks_nodejs][:npm_install_options])


  node[:dependencies][:npms].each do |npm, version|
    execute "/usr/local/bin/npm install #{npm}" do
      cwd "#{deploy[:deploy_to]}/current"
    end
  end

  # Not sure what opsworks does with this, but we'll preserve it
  template "#{deploy[:deploy_to]}/shared/config/opsworks.js" do
    cookbook 'opsworks_nodejs'
    source 'opsworks.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:database => deploy[:database], :memcached => deploy[:memcached], :layers => node[:opsworks][:layers])
  end

  template "#{deploy[:deploy_to]}/current/pm2-app.json" do
    source 'pm2-application.json.erb'
    cookbook '3i-deploy'
    user deploy[:user]
    group deploy[:group]
    variables(
      :application_name => application,
      :cwd => "#{deploy[:deploy_to]}/current/housecleaning",
      :script => "cron.js",
      :environment => deploy[:environment_variables]
    )
  end
  
end 
