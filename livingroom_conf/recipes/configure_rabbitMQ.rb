
include_recipe 'rabbitmq::mgmt_console'

rabbitmq_vhost "article-herald" do
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
  vhost "article-herald"
  permissions ".* .* .*"
  action :set_permissions
end

rabbitmq_user node['rabbitmq-settings']['admin-user'] do
  tag "administrator"
  action :set_tags
end

# user for the herald to use - no configure rights
# read/write anywhere in the vhost
rabbitmq_user 'herald' do
  password node['rabbitmq-settings']['herald-password']
  action :add
end

rabbitmq_user 'herald' do
  vhost "article-herald"
  permissions "^$ .* .*"
  action :set_permissions
end

# user for the CMS to use - no configure rights
# read/write anywhere in the vhost

rabbitmq_user 'browzinecms' do
  password node['rabbitmq-settings']['browzinecms-password']
  action :add
end

rabbitmq_user 'browzinecms' do
  vhost "article-herald"
  permissions "^$ .* .*"
  action :set_permissions
end



livingroom_conf_exchange "metadata-updates-exchange" do
  vhost "article-herald"
  type "fanout"
  durable true
  action :declare
end

livingroom_conf_queue "user-db-updates" do
  vhost "article-herald"
  durable true
  action :declare
end

livingroom_conf_binding "updates-queue-binding" do
  vhost "article-herald"
  queue "user-db-updates"
  exchange "metadata-updates-exchange"
  action :declare
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
    :logentries_token => "ef2fb4d0-32f6-4444-bc55-73adbb22e899"
  )
  notifies :restart, "service[rsyslog]", :immediately
end
