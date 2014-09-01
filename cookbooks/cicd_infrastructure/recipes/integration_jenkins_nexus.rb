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

directory "#{node['jenkins']['master']['home']}/.m2/" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0755
  action :create
end

nexus_config = node['cicd_infrastructure']['nexus']

template "#{node['jenkins']['master']['home']}/.m2/settings.xml" do
  source 'jenkins/settings.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    nexus_username:			node['cicd_infrastructure']['nexus']['login'],
    nexus_password:			node['cicd_infrastructure']['nexus']['password'],
    nexus_url:				node['cicd_infrastructure']['jenkins']['nexus']['endpoint'],
    settings_id:			node['cicd_infrastructure']['jenkins']['cfg_provider']['settings_id'],
    cfg_plugin_version:		node['cicd_infrastructure']['jenkins']['plugins']['config-file-provider'],
    jbehave_framework_repo_id:		nexus_config['repo']['jbehave']['id'],
    jbehave_framework_repo_name:	nexus_config['repo']['jbehave']['name'],
    jbehave_framework_repo_policy:	nexus_config['repo']['jbehave']['policy'],
    jbehave_framework_repo_location:	nexus_config['repo']['jbehave']['location'],
    jbehave_framework_repo_username:	nexus_config['repo']['jbehave']['username'],
    jbehave_framework_repo_password:	nexus_config['repo']['jbehave']['password'],
    use_jbehave_proxy:			nexus_config['repo']['jbehave']['use']
  )
end

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
    cfg_plugin_version: node['cicd_infrastructure']['jenkins']['plugins']['config-file-provider']
  )
  notifies :restart, 'service[jenkins]'
end
