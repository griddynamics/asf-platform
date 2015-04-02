# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Recipe:: integration_gerrit_ldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

gerrit_config = node['cicd_infrastructure']['gerrit']

node.set['gerrit']['auth']['type'] = gerrit_config['auth']['type']
node.set['gerrit']['ldap'] = gerrit_config['ldap']
node.set['gerrit']['ldap']['server'] = "ldap://#{node['gerrit']['ldap']['server']}"
node.set['gerrit']['sendemail'] = node['cicd_infrastructure']['gerrit']['sendemail']

service 'gerrit' do
  action :nothing
end

template "#{node['gerrit']['install_dir']}/etc/gerrit.config" do
  source 'gerrit/gerrit.config.erb'
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0644
  notifies :restart, 'service[gerrit]'
end

ruby_block 'match_ldap_groups' do
  block do
    require 'mysql'
    db = Mysql.new(node['gerrit']['database']['host'],
                   node['gerrit']['database']['username'],
                   node['gerrit']['database']['password'],
                   node['gerrit']['database']['name'])
    db.query("INSERT INTO account_group_by_id (GROUP_ID, INCLUDE_UUID) \
                 SELECT group_id, 'ldap:cn=administrators,ou=groups,dc=asf,dc=griddynamics,dc=com' \
                         FROM account_group_names WHERE NAME='Administrators';")
    db.close
  end
  retries 5
  retry_delay 30
end
