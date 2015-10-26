# binding resource
# used for configuring a binding between a rabbitmq queue and a rabbitmq exchange
#
# EX:
#
# livingroom_conf_binding "my-binding" do
#   vhost "/myvhost"
#   queue "queue-to-bind"
#   exchange "exchange-to-bind"
# end
#

actions :declare, :delete
default_action :declare

attribute :vhost, :kind_of => String, :default => 'default_vhost'
attribute :name, :kind_of => String, :name_attribute => true
attribute :queue, :kind_of => String, :default => 'default_queue'
attribute :exchange, :kind_of => String, :default => 'default exchange'

#catch-all attrs attribute for anything else I didn't explicitly create an attribute for
attribute :attrs, :kind_of => Hash, :default => {}
