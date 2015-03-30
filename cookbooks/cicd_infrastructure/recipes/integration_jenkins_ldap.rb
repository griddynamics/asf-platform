# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_ldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

jenkins_ldap_config = node['cicd_infrastructure']['jenkins']['ldap']

jenkins_ldap_auth 'Configure jenkins ldap' do
  auth node['cicd_infrastructure']['jenkins']['auth']
  server jenkins_ldap_config['server']
  port jenkins_ldap_config['port']
  basedn jenkins_ldap_config['basedn']
  userdn jenkins_ldap_config['userdn']
  user_id jenkins_ldap_config['user_id']
  rootdn jenkins_ldap_config['rootdn']
  root_pwd Base64.encode64(jenkins_ldap_config['root_pwd'])
end

service 'jenkins' do
  action :restart
end
