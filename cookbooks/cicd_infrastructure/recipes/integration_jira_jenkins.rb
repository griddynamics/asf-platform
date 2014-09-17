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

node['cicd_infrastructure']['jira']['plugins'].each do |plugin, plugin_attrs|
  download_dir = if plugin_attrs['type'] == 'jar'
                   "#{node['jira']['home_path']}/plugins/installed-plugins"
                 else
                   Chef::Config[:file_cache_path]
                 end

  execute "unpacking #{plugin}" do
    command "unzip -j #{download_dir}/#{plugin}.obr *.jar"
    user 'root'
    cwd "#{node['jira']['home_path']}/plugins/installed-plugins"
    creates "#{plugin}.jar"
    not_if { plugin_attrs['type'] == 'jar' }
    action :nothing
  end

  remote_file "#{download_dir}/#{plugin}.#{plugin_attrs['type']}" do
    owner node['jira']['user']
    mode 0755
    source plugin_attrs['url']
    only_if { Dir["#{download_dir}/*#{plugin}*.jar"].empty? }
    notifies :run, "execute[unpacking #{plugin}]",:immediately
  end
end

service 'jira' do
  action :restart
end
