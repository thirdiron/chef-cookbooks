nodejs_npm 'pm2' do
  version '2.10.1'
end

# Set .pm2 folder permissions so ubuntu user
# can update things
directory "#{node['3i-nodejs']['cloud_homedir']}/.pm2" do
  owner node['3i-nodejs']['cloud_user']
  group node['3i-nodejs']['cloud_group']
  # mode '0755'
end

# set the modules folder owner to ubuntu
# so the ubuntu user can actually install modules
# (like the server monitor module)
directory "/home/#{node['3i-nodejs']['cloud_user']}/.pm2/modules" do
  owner node['3i-nodejs']['cloud_user']
  group 'root'
  # mode '0755'
  recursive true
  action :create
end

execute 'setup-pm2-startup-script' do
  command "env PATH=$PATH:/usr/bin pm2 startup -u #{node['3i-nodejs']['cloud_user']} --hp #{node['3i-nodejs']['cloud_homedir']}"
  user 'root'
end

execute 'link-pm2-to-keymetrics' do
  command "pm2 link #{node['keymetrics']['secret-key']} #{node['keymetrics']['public-key']}"
  user node['3i-nodejs']['cloud_user']
  environment ({ 'HOME' => node['3i-nodejs']['cloud_user'] })
  not_if { node['keymetrics']['secret-key'] == '' }
end
