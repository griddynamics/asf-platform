# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jenkins_ldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'jenkins' do
  action :nothing
end

package 'git' do
  action :install
end

gerrit_config = node['cicd_infrastructure']['jenkins']['gerrit-trigger']
nexus_config = node['cicd_infrastructure']['jenkins']['nexus']
jira_config = node['cicd_infrastructure']['jenkins']['jira']

execute 'Checkout jobs repo' do
  command "git clone ssh://jenkins@#{gerrit_config['host']}:#{gerrit_config['ssh_port']}/asf-webapp-jenkins-jobs"
  cwd '/tmp'
  user node['jenkins']['master']['user']
  action :run
  retries 5
  retry_delay 30
  not_if { File.exists?('/tmp/asf-webapp-jenkins-jobs') }
end

template '/tmp/asf-webapp-jenkins-jobs/asf-demo-jobs.groovy' do
  source 'integration/jenkins/jobs/asf-demo-jobs.groovy.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    project_name: 'asf-webapp-demo',
    gerrit_host: gerrit_config['host'],
    gerrit_port: gerrit_config['ssh_port'],
    nexus_id: 'asf-webapp-demo',
    nexus_url: nexus_config['endpoint'],
    jira_host: jira_config['host'],
    settings_id: node['cicd_infrastructure']['jenkins']['cfg_provider']['settings_id'],
    plugins: node['cicd_infrastructure']['jenkins']['plugins'],
    qubell_plugin_version: node['cicd_infrastructure']['jenkins']['qubell-plugin']['version'],
  )
end

bash 'Push jobs to repo' do
  user node['jenkins']['master']['user']
  cwd '/tmp/asf-webapp-jenkins-jobs'
  code <<-EOH
  git add asf-demo-jobs.groovy
  git commit -m 'Add asf-webapp-demo jobs'
  git push origin master
  EOH
  retries 5
  retry_delay 30
end

template "#{Chef::Config['file_cache_path']}/asf-jobs.xml" do
  source 'integration/jenkins/jobs/asf-demo-jobs.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    gerrit_host: gerrit_config['host'],
    gerrit_port: gerrit_config['ssh_port'],
    qubell_default_app_id: node['cicd_infrastructure']['qubell_default_app_id'],
    qubell_default_env_id: node['cicd_infrastructure']['qubell_default_env_id']
  )
  notifies :restart, 'service[jenkins]'
end

jenkins_job 'asf-demo-jobs-generator' do
  config "#{Chef::Config['file_cache_path']}/asf-jobs.xml"
  action :create
  not_if { File.directory? "#{node['jenkins']['master']['home']}/jobs/asf-demo-jobs-generator" }
end
