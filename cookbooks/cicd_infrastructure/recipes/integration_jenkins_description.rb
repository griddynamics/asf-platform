# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_description
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'jenkins' do
  action :nothing
end

template "#{node['jenkins']['master']['home']}/config.xml" do
  source 'integration/jenkins/config.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    gerrit_host:    node['cicd_infrastructure']['jenkins']['gerrit-trigger']['host'],
    nexus_host:     node['cicd_infrastructure']['jenkins']['nexus']['endpoint'],
    jira_host:      node['cicd_infrastructure']['jenkins']['jira']['host'],
    sonar_host:     node['cicd_infrastructure']['jenkins']['sonar']['host'],
    sonar_port:     node['cicd_infrastructure']['jenkins']['sonar']['port'],
    jdk_version: node['cicd_infrastructure']['jenkins']['ec2']['jdkVersion'],
    jdk_installation_url: node['cicd_infrastructure']['jenkins']['ec2']['jdkInstallationUrl']
  )
  notifies :restart, 'service[jenkins]'
end
