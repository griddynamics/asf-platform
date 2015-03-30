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
  not_if { File.exist?('/tmp/asf-webapp-jenkins-jobs') }
end

{
      "GERRIT_HOST" => gerrit_config['host'],
      "GERRIT_PORT" => gerrit_config['ssh_port'],
      "NEXUS_ID" => 'asf-webapp-demo',
      "NEXUS_URL" => nexus_config['endpoint'],
      "JIRA_HOST" => jira_config['host'],
      "SETTINGS_ID" => node['cicd_infrastructure']['jenkins']['cfg_provider']['settings_id'],
      "GIT_CREDS" => node['cicd_infrastructure']['jenkins']['ec2']['slaveCredentials'],
      "MAVEN_VERSION" => node['cicd_infrastructure']['jenkins']['ec2']['mavenVersion'],
      "ANT_VERSION" => node['cicd_infrastructure']['jenkins']['ec2']['antVersion'],
      "GROOVY_VERSION" => node['cicd_infrastructure']['jenkins']['ec2']['groovyVersion'],
      "JDK_VERSION" => node['cicd_infrastructure']['jenkins']['ec2']['jdkVersion']
}.each do |env_name, env_var|
    add_jenkins_global_var 'Add nexus env variables' do
      key env_name
      value env_var
    end
end

service 'jenkins' do
  action :restart
end

remote_directory '/tmp/asf-webapp-jenkins-jobs/helpers' do
  source 'jenkins/helpers'
  group 'root'
  owner 'root'
  mode 0755
  recursive true
  action :create
end

remote_directory '/tmp/asf-webapp-jenkins-jobs' do
  source 'jenkins/asf-webapp'
  group 'root'
  owner 'root'
  mode 0755
  recursive true
  action :create
end

bash 'Push jobs to repo' do
  user node['jenkins']['master']['user']
  cwd '/tmp/asf-webapp-jenkins-jobs'
  code <<-EOH
  git add .
  git commit -m 'Add asf-webapp-demo jobs'
  git push origin master
  EOH
  retries 5
  retry_delay 30
end

template "#{Chef::Config['file_cache_path']}/asf-jobs.xml" do
  source 'integration/jenkins/jobs/asf-webapp/asf-demo-jobs.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    gerrit_host: gerrit_config['host'],
    gerrit_port: gerrit_config['ssh_port'],
    qubell_default_app_id: node['cicd_infrastructure']['qubell_default_app_id'],
    qubell_default_env_id: node['cicd_infrastructure']['qubell_default_env_id'],
    git_creds: node['cicd_infrastructure']['jenkins']['ec2']['slaveCredentials']
  )
  notifies :restart, 'service[jenkins]'
end

jenkins_job 'asf-demo-jobs-generator' do
  config "#{Chef::Config['file_cache_path']}/asf-jobs.xml"
  action :create
  not_if { File.directory? "#{node['jenkins']['master']['home']}/jobs/asf-demo-jobs-generator" }
end
