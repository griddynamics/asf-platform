# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_sonar_ldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'sonarqube' do
  action :nothing
end

if node['cicd_infrastructure']['sonar']['auth'] == 'LDAP'
  sonar_plugin 'sonar-ldap-plugin' do
    version '1.4'
  end

  sonar_ldap_config = node['cicd_infrastructure']['sonar']['ldap']

  template "#{node['sonarqube']['dir']}/conf/ldap.properties" do
    source 'sonar/sonar.properties.ldap.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      server: sonar_ldap_config['server'],
      port: sonar_ldap_config['port'],
      security_realm: sonar_ldap_config['security']['realm'],
      realm: sonar_ldap_config['realm'],
      rootdn: sonar_ldap_config['rootdn'],
      root_pwd: sonar_ldap_config['root_pwd'],
      userdn: sonar_ldap_config['userdn'],
      groupdn: sonar_ldap_config['groupdn']
    )
  end

  wait_for_sonar 'Wait for sonar' do
    sonar_host 'localhost'
    sonar_port node['cicd_infrastructure']['jenkins']['sonar']['port']
    attempts 60
  end

  execute 'Add LDAP properties to ldap.properties file' do
    user 'root'
    command "cat #{node['sonarqube']['dir']}/conf/ldap.properties >> \
      #{node['sonarqube']['dir']}/conf/sonar.properties"
    notifies :restart, 'service[sonarqube]'
  end
end
