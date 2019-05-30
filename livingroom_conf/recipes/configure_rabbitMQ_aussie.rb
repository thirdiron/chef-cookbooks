
include_recipe 'rabbitmq::mgmt_console'

rabbitmq_vhost "aussie" do
  action :add
end

rabbitmq_user "guest" do
  action :delete
end

rabbitmq_user node['rabbitmq-settings']['admin-user'] do
  password node['rabbitmq-settings']['admin-password']
  action :add
end

rabbitmq_user node['rabbitmq-settings']['admin-user'] do
  vhost "aussie"
  permissions ".* .* .*"
  action :set_permissions
end

rabbitmq_user node['rabbitmq-settings']['admin-user'] do
  tag "administrator"
  action :set_tags
end

# user for the aussie to use - no configure rights
# read/write anywhere in the vhost
rabbitmq_user 'aussie' do
  password node['rabbitmq-settings']['aussie-password']
  action :add
end

rabbitmq_user 'aussie' do
  vhost "aussie"
  permissions ".* .* .*"
  action :set_permissions
end

# user for the CMS to use - no configure rights
# read/write anywhere in the vhost
rabbitmq_user 'browzinecms' do
  password node['rabbitmq-settings']['browzinecms-password']
  action :add
end

rabbitmq_user 'browzinecms' do
  vhost "aussie"
  permissions ".* .* .*"
  action :set_permissions
end

rabbitmq_user 'metadatacollector' do
  password node['rabbitmq-settings']['metadatacollector-password']
  action :add
end

rabbitmq_user 'metadatacollector' do
  vhost "aussie"
  permissions ".* .* .*"
  action :set_permissions
end

# Need to mention rsyslog so template updates
# can notify with the :restart command
service 'rsyslog' do
  :nothing
end

# Configure logs to go to logentries
template "/etc/rsyslog.d/70-rabbitmq.conf" do
  source '70-rabbitmq.conf.erb'
  cookbook 'livingroom_conf'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :hostname => node["opsworks"]["instance"]["hostname"],
    :logentries_token => node["rabbitmq-settings"]["logentries-token"]
  )
  notifies :restart, "service[rsyslog]", :immediately
end
