# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: openldap_init_root
#
# Copyright 2014, Grid Dynamics International, Inc.
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
