default['couch_db']['config']['httpd']['bind_address'] = "0.0.0.0"

default['couch_db']['config']['couchdb']['max_dbs_open'] = 32000;
default['couch_db']['config']['httpd']['max_connections'] = 100000;

default['3i_couch_db']['num_erlang_threads'] = 4
