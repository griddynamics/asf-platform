# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: openldap_init_root
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

template "#{Chef::Config[:file_cache_path]}/initial.ldif" do
  source 'openldap/initial.ldif.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(basedn: node['openldap']['basedn'])
end

bash "setup #{node['openldap']['basedn']} database" do
  user 'root'
  code <<-EOH
  ldapadd -Y EXTERNAL -H ldapi:/// \
  -f #{Chef::Config[:file_cache_path]}/initial.ldif
  EOH
  action :run
  only_if { File.exist?("#{Chef::Config[:file_cache_path]}/initial.ldif") }
  retries 5
  retry_delay 30
end

template "#{Chef::Config[:file_cache_path]}/root.ldif" do
  source 'openldap/root.ldif.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(basedn: node['openldap']['basedn'])
end

bash 'create ldap root structure' do
  user 'root'
  code <<-EOH
  ldapadd -x -w #{node['openldap']['rootpw']} -c \
  -D "cn=admin,#{node['openldap']['basedn']}" \
  -f #{Chef::Config[:file_cache_path]}/root.ldif
  EOH
  only_if { File.exist?("#{Chef::Config[:file_cache_path]}/root.ldif") }
  action :run
end
