nodejs_npm "pm2" do
  version "1.0.2"
end

execute "setup-pm2-startup-script" do
  command 'env PATH=$PATH:/usr/bin pm2 startup ubuntu -u ubuntu --hp /home/ubuntu'
  user 'root'
end

execute "connect-pm2-to-keymetrics" do 
  command 'pm2 link $KEYMETRICS_SECRET $KEYMETRICS_PUBLIC'
  user 'root'
end