# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_jira
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

jira_config = node['cicd_infrastructure']['jenkins']['jira']

# jenkins_plugin 'jira-plugin' do
#   source jira_config['plugin']['url']
#   retries 5
#   retry_delay 30
#   action :install
# end
#

service 'jenkins' do
  action :nothing
end

template "#{node['jenkins']['master']['home']}/hudson.plugins.jira.JiraProjectProperty.xml" do
  source 'integration/jenkins/hudson.plugins.jira.JiraProjectProperty.xml'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    jira_host: jira_config['host'],
    jira_username: jira_config['username'],
    jira_password: jira_config['password']
  )
  notifies :restart, 'service[jenkins]'
end

