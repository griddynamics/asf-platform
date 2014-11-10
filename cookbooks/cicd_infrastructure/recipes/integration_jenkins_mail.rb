# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_mail
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

include_recipe 'postfix'

service 'jenkins' do
  action :nothing
end

mail_config = node['cicd_infrastructure']['jenkins']['mail']
jenkins = node['jenkins']['master']

template "#{jenkins['home']}/hudson.tasks.Mailer.xml" do
  source 'integration/jenkins/hudson.tasks.Mailer.xml.erb'
  owner jenkins['user']
  group jenkins['group']
  mode 0644
  variables(
    plugin_version: node['cicd_infrastructure']['jenkins']['plugins']['mailer'],
    smtp_host: mail_config['smtp']['host']
  )
  notifies :restart, 'service[jenkins]'
end

template "#{jenkins['home']}/hudson.plugins.emailext.ExtendedEmailPublisher.xml" do
  source 'integration/jenkins/hudson.plugins.emailext.ExtendedEmailPublisher.xml.erb'
  owner jenkins['user']
  group jenkins['group']
  mode 0644
  variables(
    plugin_version: node['cicd_infrastructure']['jenkins']['plugins']['email-ext'],
    smtp_host: mail_config['smtp']['host']
  )
  notifies :restart, 'service[jenkins]'
end

template "#{jenkins['home']}/jenkins.model.JenkinsLocationConfiguration.xml" do
  source 'integration/jenkins/jenkins.model.JenkinsLocationConfiguration.xml.erb'
  owner jenkins['user']
  group jenkins['group']
  mode 0644
  variables(
    jenkins_email: mail_config['address'],
    jenkins_host: jenkins['host'],
    jenkins_port: jenkins['port']
  )
  notifies :restart, 'service[jenkins]'
end