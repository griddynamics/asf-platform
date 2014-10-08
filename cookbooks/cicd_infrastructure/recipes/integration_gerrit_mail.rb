# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_gerrit_mail
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

node.set['gerrit']['sendemail'] = node['cicd_infrastructure']['gerrit']['sendemail']

service 'gerrit' do
  action :nothing
end

template "#{node['gerrit']['install_dir']}/etc/gerrit.config" do
  source 'gerrit/gerrit.config.erb'
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0644
  notifies :restart, 'service[gerrit]'
end
