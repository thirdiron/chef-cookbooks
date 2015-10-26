def whyrun_supported?
# false for now while I'm learning how to implement a custom provider
  false
end

use_inline_resources

action :declare do
  if !exists?
    # Beats me why I would have to install this myself
    # But I'm getting an error from the rabbitmq gem
#    chef_gem 'faraday' do
#      version '0.8.11'
#    end

    chef_gem 'rabbitmq_http_api_client' do
      version '1.3.0'
    end
    require 'rabbitmq/http/client'
    client = RabbitMQ::HTTP::Client.new(
      "http://127.0.0.1:15672",
      username: 'admin',
      password: 'admin',
      ssl: {}
    )

    explicit_attrs = {
      :type => new_resource.type,
      :durable => new_resource.durable
    }


    client.declare_exchange(new_resource.vhost, 
                            new_resource.name, 
                            explicit_attrs.merge(new_resource.attrs))
  end

end

def exists?
  return false
end

