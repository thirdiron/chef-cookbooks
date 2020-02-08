# override the repo attribute so we get node 8.x
default['nodejs']['repo'] = 'https://deb.nodesource.com/node_8.x'

default['3i-nodejs']['cloud_user'] = 'ubuntu'
default['3i-nodejs']['cloud_group'] = 'ubuntu'
default['3i-nodejs']['cloud_homedir'] = '/home/ubuntu'

# Keystore Attribute stubs
default['keymetrics']['public-key'] = 'sehdxnrd5il525r'
default['keymetrics']['secret-key'] = ''
