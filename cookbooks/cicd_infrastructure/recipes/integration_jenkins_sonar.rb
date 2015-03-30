# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_sonar
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

sonar = node['cicd_infrastructure']['jenkins']['sonar']
jenkins = node['jenkins']['master']

service 'jenkins' do
  action :nothing
end

template "#{jenkins['home']}/hudson.plugins.sonar.SonarPublisher.xml" do
  source 'integration/jenkins/hudson.plugins.sonar.SonarPublisher.xml.erb'
  owner jenkins['user']
  group jenkins['group']
  mode 0644
  variables(
    plugin_version: node['cicd_infrastructure']['jenkins']['plugins']['sonar'],
    sonar_host: sonar['host'],
    sonar_private_ip: sonar['private_ip'],
    sonar_port: sonar['port'],
    sonar_username: sonar['username'],
    sonar_password: sonar['password']
  )
  notifies :restart, 'service[jenkins]'
end
