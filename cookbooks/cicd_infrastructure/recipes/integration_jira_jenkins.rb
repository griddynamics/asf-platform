# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: integration_jira_jenkins
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

package 'unzip'

Chef::Config[:file_cache_path] = '/tmp'

node['cicd_infrastructure']['jira']['plugins'].each do |plugin_url|
  remote_file "#{Chef::Config[:file_cache_path]}/#{File.basename(plugin_url)}" do
    owner node['jira']['user']
    mode 0644
    source plugin_url
  end

  execute "unzip -j #{Chef::Config[:file_cache_path]}/#{File.basename(plugin_url)} #{File.basename(plugin_url, '.*')}.jar" do
    user 'root'
    cwd "#{node['jira']['home_path']}/plugins/installed-plugins"
    creates "#{File.basename(plugin_url, '.*')}.jar"
  end
end

service 'jira' do
  action :restart
end

