# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_jira
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

jira = node['cicd_infrastructure']['jenkins']['jira']
jenkins = node['jenkins']['master']

# jenkins_plugin 'jira-plugin' do
#   source jira_config['plugin']['url']
#   retries 5
#   retry_delay 30
#   action :install
# end

service 'jenkins' do
  action :nothing
end

add_jenkins_global_var 'Add Jenkins_URL env variables' do
  key 'Jenkins URL'
  value "http://#{node['jenkins']['master']['host']}:#{node['jenkins']['master']['port']}"
  notifies :restart, 'service[jenkins]'
end

template "#{jenkins['home']}/hudson.plugins.jira.JiraProjectProperty.xml" do
  source 'integration/jenkins/hudson.plugins.jira.JiraProjectProperty.xml.erb'
  owner jenkins['user']
  group jenkins['group']
  mode 0644
  variables(
    jira_host: jira['host'],
    jira_username: jira['username'],
    jira_password: jira['password']
  )
  notifies :restart, 'service[jenkins]'
end

