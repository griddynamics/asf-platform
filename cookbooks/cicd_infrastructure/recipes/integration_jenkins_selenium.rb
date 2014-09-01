# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_jenkins_selenium
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'jenkins' do
  action :nothing
end

add_jenkins_global_var 'Add selenium env variables' do
  key 'SELENIUM_URL'
  value node['cicd_infrastructure']['jenkins']['selenium']['endpoint']
  notifies :restart, 'service[jenkins]'
end
