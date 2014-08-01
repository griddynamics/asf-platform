# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: nexus
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

Chef::Config[:file_cache_path] = '/var/chef/cache/'

include_recipe 'nexus::default'

if node['cicd_infrastructure']['nexus']['auth'] == 'LDAP'
  include_recipe 'cicd_infrastructure::nexus_ldap'
end
