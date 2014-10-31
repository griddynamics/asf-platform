# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: dashboard
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

include_recipe 'apache2::default'
include_recipe 'apache2::mod_alias'

install_dir = "#{node['apache']['docroot_dir']}/dashboard"

remote_directory install_dir do
  source 'dashboard'
  group node['apache']['user']
  owner node['apache']['group']
  mode 0755
  recursive true
  action :create
end

template "#{install_dir}/services.json" do
  source 'dashboard/services.json.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0755
  variables(:services => node['cicd_infrastructure']['dashboard']['services'])
end

web_app 'dashboard' do
  template 'dashboard/dashboard.conf.erb'
  path "#{node['apache']['dir']}/sites-available/dashboard.conf"
  site_alias node['cicd_infrastructure']['dashboard']['alias']
  docroot install_dir
  enable true
end

apache_site 'dashboard' do
  enable true
end
