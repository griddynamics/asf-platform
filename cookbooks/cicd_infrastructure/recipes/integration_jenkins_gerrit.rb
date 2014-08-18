# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_jenkins_gerrit
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'jenkins' do
  action :nothing
end

jenkins_ssh_dir = "#{node['jenkins']['master']['home']}/.ssh"

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
  not_if { File.exists? "#{jenkins_ssh_dir}/id_rsa" }
end

# Save public key to chef-server as jenkins_pubkey
ruby_block 'node-save-jenkins-pubkey' do
  block do
    node.set['cicd_infrastructure']['jenkins']['pubkey'] =
      File.read("#{jenkins_ssh_dir}/id_rsa.pub")
    node.save unless Chef::Config['solo']
  end
end

gerrit_trigger_config = node['cicd_infrastructure']['jenkins']['gerrit-trigger']

Chef::Log.Error 'Gerrit-trigger config failed' if gerrit_trigger_config
.values.include? nil

template "#{node['jenkins']['master']['home']}/gerrit-trigger.xml" do
  source 'integration/jenkins/gerrit-trigger.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    gerrit_host: gerrit_trigger_config['host'],
    gerrit_ssh_port: gerrit_trigger_config['ssh_port'],
    gerrit_http_port: gerrit_trigger_config['http_port'],
    jenkins_private_key: "#{jenkins_ssh_dir}/id_rsa"
  )
  notifies :restart, "service[jenkins]"
end

template "#{jenkins_ssh_dir}/config" do
  source 'integration/jenkins/ssh_config.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(gerrit_host: gerrit_trigger_config['host'])
end
