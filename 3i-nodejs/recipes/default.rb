#
# Cookbook Name:: 3i-nodejs
# Recipe:: default
#
# Copyright (C) 2015 Mike Lang
#
# All rights reserved - Do Not Redistribute
#
# include the dependent nodejs recipe, but with our module's attributes
# so we fetch the appropriate version of nodeJS
include_recipe 'nodejs::nodejs_from_package'

# The opsworks nodejs recipe is really picky about where
# nodejs is installed so we have to create a link from
# where it expects the node executable to be to where
# the nodejs cookbook installs it.
link '/usr/local/bin/node' do
  to '/usr/bin/node'
end
