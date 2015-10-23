resource_name :exchange

actions :declare, :delete
default_action :declare

attribute :vhost, :kind_of => String, :default => 'default_vhost'
attribute :name, :kind_of => String, :name_attribute => true
attribute :type, :kind_of => String, :default => 'direct'
attribute :durable, :kind_of => [ String, TrueClass, FalseClass], :default => 'true'

