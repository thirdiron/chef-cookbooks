nodejs_npm "pm2" do
  version "2.10.1"
end

execute "setup-pm2-startup-script" do
  command 'env PATH=$PATH:/usr/bin pm2 startup -u ubuntu --hp /home/ubuntu'
  user 'root'
end

execute "link-pm2-to-keymetrics" do
  command 'pm2 link #{node["keymetrics"]["secret-key"]} #{node["keymetrics"]["public-key"]}'
  user 'ubuntu'
end

execute "setup-keymetrics-server-monitoring" do
  command 'pm2 install pm2-server-monit'
  user 'ubuntu'
end
