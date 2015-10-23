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
