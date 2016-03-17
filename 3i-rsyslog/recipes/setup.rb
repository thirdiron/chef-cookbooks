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
