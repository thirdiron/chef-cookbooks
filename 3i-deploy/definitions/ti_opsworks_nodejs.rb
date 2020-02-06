define :ti_opsworks_nodejs do
  deploy = params[:deploy_data]
  application = params[:app]

  service 'monit' do
    action :nothing
  end

  # install package.json depdencencies with an npm install
  #
  execute "su #{node[:deploy][application][:user]} -c 'cd #{deploy[:deploy_to]}/current && /usr/bin/npm install'" do
    cwd "#{deploy[:deploy_to]}/current"
    user "root"
    environment node[:deploy][application][:environment_variables]
  end

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

  # For now to minimize change while iterating, continue to use monit 
  # like the standard opsworks cookbook.  Maybe should migrate to 
  # something more node specific, like pm2
  template "#{node.default[:monit][:conf_dir]}/node_web_app-#{application}.monitrc" do
    source '3i_node_web_app.monitrc.erb'
    cookbook '3i-deploy'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application,
      :monitored_script => "#{deploy[:deploy_to]}/current/server.js"
    )
    notifies :restart, "service[monit]", :immediately
  end

  file "#{deploy[:deploy_to]}/shared/config/ssl.crt" do
    owner deploy[:user]
    mode 0600
    content deploy[:ssl_certificate]
    only_if do
      deploy[:ssl_support]
    end
  end

  file "#{deploy[:deploy_to]}/shared/config/ssl.key" do
    owner deploy[:user]
    mode 0600
    content deploy[:ssl_certificate_key]
    only_if do
      deploy[:ssl_support]
    end
  end

  file "#{deploy[:deploy_to]}/shared/config/ssl.ca" do
    owner deploy[:user]
    mode 0600
    content deploy[:ssl_certificate_ca]
    only_if do
      deploy[:ssl_support] && deploy[:ssl_certificate_ca].present?
    end
  end
end
