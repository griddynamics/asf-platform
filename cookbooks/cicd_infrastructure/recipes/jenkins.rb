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

template "#{node['jenkins']['master']['home']}/config.xml" do
  source 'jenkins/config.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  notifies :restart, "service[jenkins]"
end

[
    'hudson.tasks.Maven.xml',
    'hudson.plugins.groovy.Groovy.xml'
].each do |config|
    template "#{node[:jenkins][:master][:home]}/#{config}" do
        source "jenkins/#{config}.erb"
        owner node[:jenkins][:master][:user]
        group node[:jenkins][:master][:group]
        mode 0755
        notifies :restart, 'service[jenkins]'
    end
end

