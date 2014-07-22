# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: nexus
#
# Copyright 2014, Grid Dynamics International, Inc.
#

Chef::Config[:file_cache_path] = '/var/chef/cache/'

include_recipe 'nexus::default'

if node['cicd_infrastructure']['nexus']['auth'] == 'LDAP'
  include_recipe 'cicd_infrastructure::nexus_ldap'
end
