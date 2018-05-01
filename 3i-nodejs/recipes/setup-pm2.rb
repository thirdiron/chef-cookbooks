nodejs_npm "pm2" do
  version "2.10.1"
end

# set the modules folder owner to ubuntu
# so the ubuntu user can actually install modules
# (like the server monitor module)
directory '/home/ubuntu/.pm2/modules' do
  owner 'ubuntu'
  group 'root'
  mode '0755'
  action :create
end

execute "setup-pm2-startup-script" do
  command 'env PATH=$PATH:/usr/bin pm2 startup -u ubuntu --hp /home/ubuntu'
  user 'root'
end

execute "link-pm2-to-keymetrics" do
  command "pm2 link #{node['keymetrics']['secret-key']} #{node['keymetrics']['public-key']}"
  user 'ubuntu'
  environment ({'HOME' => '/home/ubuntu'})
end

execute "setup-keymetrics-server-monitoring" do
  command 'pm2 install pm2-server-monit'
  user 'ubuntu'
  environment ({'HOME' => '/home/ubuntu'})
end

execute "install-pm2-typescript-runner" do
  command 'pm2 install typescript'
  user 'ubuntu'
  environment ({'HOME' => '/home/ubuntu'})
end