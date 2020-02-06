define :ti_opsworks_pm2_nodejs do
  deploy = params[:deploy_data]
  application = params[:app]

  # install package.json depdencencies with an npm install
  #
  #
  execute "su #{node[:deploy][application][:user]} -c 'cd #{deploy[:deploy_to]}/current && /usr/bin/npm install'" do
    cwd "#{deploy[:deploy_to]}/current"
    user "root"
    environment node[:deploy][application][:environment_variables]
  end

  node[:dependencies][:npms].each do |npm, version|
    execute "/usr/bin/npm install #{npm}" do
      cwd node[:release_path]
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
      :cwd => "#{deploy[:deploy_to]}/current",
      :script => deploy[:environment_variables]['NODEJS_PM2_ENTRY_POINT'],
      :environment => deploy[:environment_variables]
    )
  end
  
end 
