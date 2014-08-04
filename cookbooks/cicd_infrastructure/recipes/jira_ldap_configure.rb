# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: jira
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

jira_ldap_config = node['cicd_infrastructure']['jira']['ldap']
jira_host = node['jira']['apache2']['virtual_host_name']

execute "configure ldap" do
    user "root"
    command "mysql -ujira -pchangeit jira < /ldap_configure.sql"
    action :nothing
end

execute "configure database" do
    user "root"
    command "curl -k https://#{jira_host}/secure/SetupDatabase.jspa"
    action :nothing
end

template "#{node['jira']['work_dir']}/ldap_configure.sql" do
  source 'jira/ldap_configure.sql.erb'
  owner node['jira']['user']
  group node['jira']['group']
  mode 0644
  variables(
    host:         jira_ldap_config['host'],
    port:         jira_ldap_config['port'],
    basedn:       jira_ldap_config['basedn'],
    rootdn:       jira_ldap_config['rootdn'],
    root_pwd:     jira_ldap_config['root_pwd'],
    scheme:       jira_ldap_config['scheme'],
    userdn:       jira_ldap_config['userdn'],
    user_attrs:   jira_ldap_config['user_attrs'],
    groupdn:      jira_ldap_config['groupdn'],
    group_attrs:  jira_ldap_config['group_attrs']
  )
  notifies :restart, "service[jira]", :delayed
  notifies :run, 'execute[configure database]', :delayed
  notifies :run, 'execute[configure ldap]', :delayed
end
