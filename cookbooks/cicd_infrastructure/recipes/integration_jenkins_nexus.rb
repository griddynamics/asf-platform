# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_jenkins_nexus
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service "jenkins" do
	service_name "jenkins"
	action :stop
end	

add_jenkins_global_var 'Add nexus env variables' do
	key "NEXUS_URL"
	value node["cicd_infrastructure"]["nexus"]["url"]
end

service "jenkins" do
	service_name "jenkins"
	action :start
end	

template "#{node['jenkins']['master']['home']}/maven-global-settings-files.xml" do
  source 'jenkins/maven-global-settings-files.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
	  nexus_username: node["cicd_infrastructure"]["nexus"]["login"],
	  nexus_password: node["cicd_infrastructure"]["nexus"]["password"],
	  nexus_url: node["cicd_infrastructure"]["nexus"]["url"]
  )
  notifies :restart, "service[jenkins]"
end
