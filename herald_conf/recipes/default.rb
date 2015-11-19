#
# Cookbook Name:: herald_conf
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

file '/etc/herald/certs/heraldkey.pem' do
  content node['herald_conf']['ssl_private_key']
  owner 'ubuntu'
  group 'ubuntu'
end

file '/etc/herald/certs/heraldcert.pem' do
  content node['herald_conf']['ssl_cert']
  owner 'ubuntu'
  group 'ubuntu'
end
