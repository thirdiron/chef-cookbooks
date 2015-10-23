
rabbitmq_plugin "rabbitmq_management" do
  action :enable
end

rabbitmq_vhost "/article-herald" do
  action :add
end

rabbitmq_user "guest" do
  action :delete
end

rabbitmq_user "admin" do
# Figure out how to shuttle a proper secret into here
# and replace with a proper password
  password "admin"
  action :add
end

rabbitmq_user "admin" do
  vhost "/article-herald"
  permissions ".* .* .*"
  action :set_permissions
end

rabbitmq_user "admin" do
  tag "administrator"
  action :set_tags
end

livingroom_conf_exchange "metadata-updates-exchange" do
  type "fanout"
  durable true
  action :declare
end

# CHEF STUFF HERE

# Set up the queue & bind it to the exchange

# CHEF STUFF HERE
