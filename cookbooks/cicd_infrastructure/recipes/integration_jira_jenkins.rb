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

node['cicd_infrastructure']['jira']['plugins'].each do |plugin_name, plugin_attrs|
  download_dir = if plugin_attrs['type'] == 'jar'
                   "#{node['jira']['home_path']}/plugins/installed-plugins"
                 else
                   Chef::Config[:file_cache_path]
                 end

  execute "unpacking #{plugin_name}" do
    command "unzip -j #{download_dir}/#{plugin_name}.obr *.jar"
    user 'root'
    cwd "#{node['jira']['home_path']}/plugins/installed-plugins"
    creates "#{plugin_name}.jar"
    not_if { plugin_attrs['type'] == 'jar' }
    action :nothing
  end

  remote_file "#{download_dir}/#{plugin_name}.#{plugin_attrs['type']}" do
    owner node['jira']['user']
    mode 0755
    source plugin_attrs['url']
    only_if { Dir["#{download_dir}/*#{plugin_name}*.jar"].empty? }
    notifies :run, "execute[unpacking #{plugin_name}]",:immediately
  end
end

bash "Enable Remote API Calls" do
  user "root"
  code <<-EOH
  mysql -u jira -pchangeit jira -e \
  "update propertynumber set propertyvalue=1 where id=(
    select id from propertyentry where PROPERTY_KEY='jira.option.rpc.allow')"
  EOH
end

service 'jira' do
  action :restart
end

