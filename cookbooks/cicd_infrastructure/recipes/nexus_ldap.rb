# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: nexus_ldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

nexus_ldap_config = node['cicd_infrastructure']['nexus']['ldap']

Chef::Log.Error 'Nexus LDAP configuration failed' if nexus_ldap_config.values.include? nil

service 'nexus' do
  action :nothing
end

template "#{node['nexus']['work_dir']}/conf/ldap.xml" do
  source 'nexus/ldap.xml.erb'
  owner node['nexus']['user']
  group node['nexus']['group']
  mode 0644
  variables(
    host:         nexus_ldap_config['host'],
    port:         nexus_ldap_config['port'],
    basedn:       nexus_ldap_config['basedn'],
    rootdn:       nexus_ldap_config['rootdn'],
    root_pwd:     nexus_ldap_config['root_pwd'],
    scheme:       nexus_ldap_config['scheme'],
    userdn:       nexus_ldap_config['userdn'],
    user_attrs:   nexus_ldap_config['user_attrs'],
    groupdn:      nexus_ldap_config['groupdn'],
    group_attrs:  nexus_ldap_config['group_attrs']
  )
  notifies :restart, 'service[nexus]'
end

template "#{node['nexus']['work_dir']}/conf/security-configuration.xml" do
  source 'nexus/security-configuration.xml.erb'
  owner node['nexus']['user']
  group node['nexus']['group']
  mode 0644
  notifies :restart, 'service[nexus]'
end

template "#{node['nexus']['work_dir']}/conf/security.xml" do
  source 'nexus/security.xml.erb'
  owner node['nexus']['user']
  group node['nexus']['group']
  mode 0644
  variables(
    ldap_groups: node['cicd_infrastructure']['nexus']['ldap']['group_mapping']
  )
  notifies :restart, 'service[nexus]'
end
