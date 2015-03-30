# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_jenkins_nexus
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'jenkins' do
  action :nothing
end

add_jenkins_global_var 'Add nexus env variables' do
  key 'NEXUS_URL'
  value node['cicd_infrastructure']['jenkins']['nexus']['endpoint']
  notifies :restart, 'service[jenkins]'
end

nexus_config = node['cicd_infrastructure']['nexus']

template "#{node['jenkins']['master']['home']}/maven-global-settings-files.xml" do
  source 'jenkins/maven-global-settings-files.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    nexus_username: node['cicd_infrastructure']['nexus']['login'],
    nexus_password: node['cicd_infrastructure']['nexus']['password'],
    nexus_url: node['cicd_infrastructure']['jenkins']['nexus']['endpoint'],
    settings_id: node['cicd_infrastructure']['jenkins']['cfg_provider']['settings_id'],
    cfg_plugin_version: node['cicd_infrastructure']['jenkins']['plugins']['config-file-provider'],
    gd_repo_id:         nexus_config['repo']['gd']['id'],
    gd_repo_name:       nexus_config['repo']['gd']['name']
  )
  notifies :restart, 'service[jenkins]'
end
