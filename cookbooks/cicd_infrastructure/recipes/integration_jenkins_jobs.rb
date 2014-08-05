# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_ldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

package 'git' do
  action :install
end

dsl_file_path = "#{node['jenkins']['master']['home']}/\
jobs/asf-demo-jobs-generator/workspace"

gerrit_config = node['cicd_infrastructure']['jenkins']['gerrit-trigger']
nexus_config = node['cicd_infrastructure']['jenkins']['nexus']

template "#{Chef::Config[:file_cache_path]}/asf-jobs.xml" do
  source 'integration/jenkins/jobs/asf-demo-jobs.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
end

jenkins_job 'asf-demo-jobs-generator' do
  config "#{Chef::Config[:file_cache_path]}/asf-jobs.xml"
  action :create
  not_if { File.directory? "#{node['jenkins']['master']['home']}/jobs/asf-demo-jobs-generator" }
end

directory dsl_file_path do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0755
  action :create
  recursive true
end

template "#{dsl_file_path}/asf-demo-jobs.groovy" do
  source 'integration/jenkins/jobs/asf-demo-jobs.groovy.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    project_name: 'asf-webapp-demo',
    gerrit_host: gerrit_config['host'],
    gerrit_port: gerrit_config['ssh_port'],
    nexus_id: 'asf-webapp-demo',
    nexus_url: nexus_config['endpoint']
  )
end
