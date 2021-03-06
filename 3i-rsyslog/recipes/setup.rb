include_recipe 'apt'

apt_repository 'rsyslog-official' do
  uri 'ppa:adiscon/v8-stable'
  distribution node['lsb']['codename']
end

apt_package 'rsyslog' do
  # Get rid of old rsyslog - EC2's ubuntu image defaults to
  # v 7.4.4
  action :remove
end

# install v8
apt_package 'rsyslog'

# install something to clean up old logs that may be moved to tmp
apt_package 'tmpreaper'

# Add the syslog user to the www-data group
# So it can reach standard opsworks deployed
# logs

execute 'add_user_to_group' do
  command 'usermod -a -G www-data syslog'
  user 'root'
end
