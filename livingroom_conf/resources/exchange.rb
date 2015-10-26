
actions :declare, :delete
default_action :declare

attribute :vhost, :kind_of => String, :default => 'default_vhost'
attribute :name, :kind_of => String, :name_attribute => true
# commonly used options get their own attribute to document their
# availablity
attribute :type, :kind_of => String, :default => 'direct'
attribute :durable, :kind_of => [TrueClass, FalseClass], :default => true
# they all get merged with the catch all attrs hash
# any option supported by the rabbitmq_http_api_client gem can go in through here
attribute :attrs, :kind_of => Hash, :default => {}

