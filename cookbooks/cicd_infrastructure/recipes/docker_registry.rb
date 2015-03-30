# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: docker_registry
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

include_recipe 'yum-epel::default'
include_recipe 'iptables::default'

iptables_rule 'allow_private_ips'

package 'device-mapper-event-libs' do
  action :upgrade
end

package 'docker-io' do
  action :install
end

service 'docker' do
  action :start
end

directory node['docker']['registry']['repository'] do
  mode 0755
  action :create
  recursive true
end

bash 'run-registry' do
  code <<-EOF
    docker run -d -p 5000:5000 \
    -v #{node['docker']['registry']['repository']}:/registry \
    -e STANDALONE=false \
    -e STORAGE_PATH=/registry \
    -e MIRROR_SOURCE=https://registry-1.docker.io \
    -e MIRROR_SOURCE_INDEX=https://index.docker.io \
    -e SETTINGS_FLAVOR=local \
    registry:0.7.1
  EOF
end

