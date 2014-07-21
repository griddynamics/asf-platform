# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: jenkins
#
# Copyright 2014, Grid Dynamics International, Inc.
#

include_recipe 'java::default'
include_recipe 'jenkins::master'

node['cicd_infrastructure']['jenkins']['plugins'].each do |plugin|
  jenkins_plugin plugin do
    retries 5
    retry_delay 30
    action :install
    notifies :restart, 'service[jenkins]'
  end
end
