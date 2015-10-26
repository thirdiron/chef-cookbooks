# queue resource
# used for configuring a rabbitmq queue

actions :declare, :delete
default_action :declare

attribute :vhost, :kind_of => String, :default => 'default_vhost'
attribute :name, :kind_of => String, :name_attribute => true

attribute :durable, :kind_of => [TrueClass, FalseClass], :default => true

#catch-all attrs attribute for anything else I didn't explicitly create an attribute for
attribute :attrs, :kind_of => Hash, :default => {}
