# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_ldap
#
# Copyright 2014, Grid Dynamics International, Inc.
#

jenkins_ldap_config = node['cicd_infrastructure']['jenkins']['ldap']

service 'jenkins' do
  action :nothing
end

template "#{node['jenkins']['master']['home']}/config.xml" do
  source 'jenkins/config.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    auth:       node['cicd_infrastructure']['jenkins']['auth'],
    server:     jenkins_ldap_config['server'],
    port:       jenkins_ldap_config['port'],
    basedn:     jenkins_ldap_config['basedn'],
    userdn:     jenkins_ldap_config['userdn'],
    user_id:    jenkins_ldap_config['user_id'],
    rootdn:     jenkins_ldap_config['rootdn'],
    root_pwd:   Base64.encode64(jenkins_ldap_config['root_pwd']),
  )
  notifies :restart, 'service[jenkins]'
end
