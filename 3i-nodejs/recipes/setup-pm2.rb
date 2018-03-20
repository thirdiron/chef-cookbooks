nodejs_npm "pm2" do
  version "2.10.1"
end

execute "setup-pm2-startup-script" do
  command 'env PATH=$PATH:/usr/bin pm2 startup -u ubuntu --hp /home/ubuntu'
  user 'root'
end
