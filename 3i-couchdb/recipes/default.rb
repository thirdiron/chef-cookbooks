#
# Cookbook Name:: 3i-couchdb
# Recipe:: default
#
# Copyright (C) 2015 Third Iron, LLC
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'couchdb::default'

# deposit a file to set ERL_MAX_PORTS env variable
# to instruct the erlang runtime to allow more
# connections
template '/etc/couchdb/default' do
  source 'etc_default_couchdb.erb'
  variables({
    max_connections => node['couch_db']['config']['httpd']['max_connections'],
    num_erlang_threads => node['3i-couch_db']['num_erlang_threads']
  })
end

# Deposit a /etc/security/limits.d/100-couchdb.conf file
# to tell PAM to increase system limits on file descriptors
# used by the couchdb process
template '/etc/security/limits.d/100-couchdb.conf' do
  source 'etc_security_limits_d_100_couchdb_conf'
  variables({
    max_connections => node['couch_db']['config']['httpd']['max_connections']
  })
end


