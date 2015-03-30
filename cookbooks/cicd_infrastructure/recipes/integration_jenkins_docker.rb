# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_jenkins_docker
#
# Copyright (c) 2015 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'jenkins' do
  action :nothing
end

add_jenkins_global_var 'Add DOCKER_REGISTRY variable' do
  key 'DOCKER_REGISTRY'
  value File.basename(node['cicd_infrastructure']['jenkins']['docker']['registry'])
end

add_jenkins_global_var 'Add SHIPYARD variable' do
  key 'SHIPYARD'
  value node['cicd_infrastructure']['jenkins']['docker']['shipyard']
end

service 'jenkins' do
  action :restart
end
