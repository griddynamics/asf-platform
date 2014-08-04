# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_jenkins_qubell
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

qubell_plugin_config = node['cicd_infrastructure']['jenkins']['qubell-plugin']

Chef::Application.fatal! 'Qubell plugin config incomplete' if qubell_plugin_config.values.include? nil

jenkins_plugin 'qubell-plugin' do
  source qubell_plugin_config['url']
  retries 5
  retry_delay 30
  action :install
end

template "#{node['jenkins']['master']['home']}/\
com.qubell.jenkinsci.plugins.qubell.Configuration.xml" do
  source 'integration/jenkins/qubell_plugin_config.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    username: qubell_plugin_config['username'],
    password: qubell_plugin_config['password'],
    endpoint: qubell_plugin_config['endpoint'],
    version: qubell_plugin_config['version']
  )
end
