# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: jenkins
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

include_recipe 'java::default'
include_recipe 'jenkins::master'
include_recipe 'iptables::default'

iptables_rule 'allow_private_ips'
iptables_rule 'allow_http-alt' do
  source 'jenkins/allow_http-alt.erb'
end

jenkins_ssh_dir = "#{node['jenkins']['master']['home']}/.ssh"

directory "#{node['jenkins']['master']['home']}/userContent" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0755
  action :create
end

cookbook_file "#{node['jenkins']['master']['home']}/userContent/update-center.json" do
  source 'jenkins/update-center-18.json'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
end

template "#{node['jenkins']['master']['home']}/hudson.model.UpdateCenter.xml" do
  source 'jenkins/hudson.model.UpdateCenter.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    host: node['jenkins']['master']['host'],
    port: node['jenkins']['master']['port']
    )
  notifies :restart, 'service[jenkins]', :delayed
end

node['cicd_infrastructure']['jenkins']['plugins'].each do |plugin, v|
  if v.empty?
    jenkins_plugin plugin do
      retries 5
      retry_delay 30
      action :install
      notifies :restart, 'service[jenkins]'
    end
  else
    jenkins_plugin plugin do
      version v
      retries 5
      retry_delay 30
      action :install
      notifies :restart, 'service[jenkins]'
    end
  end
end

%w(xunit jbehave).each do |plugin|
  jenkins_plugin plugin do
    source node['cicd_infrastructure']['jenkins']['plugin'][plugin]['url']
  end
end

jenkins_plugin 'translation' do
  action :disable
end

template "#{node['jenkins']['master']['home']}/config.xml" do
  source 'jenkins/config.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  notifies :restart, 'service[jenkins]'
end

[
  'hudson.tasks.Maven.xml',
  'hudson.plugins.groovy.Groovy.xml',
  'hudson.tasks.Shell.xml',
  'com.sonyericsson.rebuild.RebuildDescriptor.xml',
  'hudson.tasks.Ant.xml'
].each do |config|
  template "#{node['jenkins']['master']['home']}/#{config}" do
    source "jenkins/#{config}.erb"
    owner node['jenkins']['master']['user']
    group node['jenkins']['master']['group']
    mode 0644
    variables(
      maven_version: node['cicd_infrastructure']['jenkins']['ec2']['mavenVersion'],
      ant_version: node['cicd_infrastructure']['jenkins']['ec2']['antVersion'],
      groovy_version: node['cicd_infrastructure']['jenkins']['ec2']['groovyVersion'],
      maven_intallation_url: node['cicd_infrastructure']['jenkins']['ec2']['mavenInstallationUrl'],
      ant_intallation_url: node['cicd_infrastructure']['jenkins']['ec2']['antInstallationUrl'],
      groovy_intallation_url: node['cicd_infrastructure']['jenkins']['ec2']['groovyInstallationUrl']
      )
    notifies :restart, 'service[jenkins]'
  end
end

directory jenkins_ssh_dir do
  action :create
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0755'
end

ssh_keys jenkins_ssh_dir do
  user node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  action :create
  not_if { File.exist? "#{jenkins_ssh_dir}/id_rsa" }
end

jenkins_private_key_credentials 'jenkins' do
  id node['cicd_infrastructure']['jenkins']['ec2']['slaveCredentials']
  description 'jenkins-master-key'
  private_key lazy { IO.read("#{jenkins_ssh_dir}/id_rsa") }
end

jenkins_password_credentials node['cicd_infrastructure']['jenkins']['nexus']['username'] do
  description 'Nexus user'
  id 'e27d81bd-3c1e-4a30-ac68-da043fb5ecb4'
  password node['cicd_infrastructure']['jenkins']['nexus']['password']
end
