# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_gerrit_openldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

gerrit_config = node['cicd_infrastructure']['gerrit']

node.set['gerrit']['auth']['type'] = gerrit_config['auth']['type']
node.set['gerrit']['ldap'] = gerrit_config['ldap']
node.set['gerrit']['ldap']['server'] = "ldap://#{node['gerrit']['ldap']['server']}"
service 'gerrit' do
  action :nothing
end

template "#{node['gerrit']['install_dir']}/etc/gerrit.config" do
  source 'gerrit/gerrit.config'
  cookbook 'gerrit'
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0644
  notifies :restart, 'service[gerrit]'
end
