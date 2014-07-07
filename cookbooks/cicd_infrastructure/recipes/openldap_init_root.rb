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

execute "register cn=admin,#{node['openldap']['basedn']}" do
  command "ldapadd -Y EXTERNAL -H ldapi:/// \
  -f #{Chef::Config[:file_cache_path]}/initial.ldif"
  user 'root'
  action :run
  only_if { File.exist?("#{Chef::Config[:file_cache_path]}/initial.ldif") }
end

template "#{Chef::Config[:file_cache_path]}/root.ldif" do
  source 'openldap/root.ldif.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(basedn: node['openldap']['basedn'])
  notifies :stop, 'service[slapd]', :immediately
end

bash 'create ldap root structure' do
  user 'root'
  code <<-EOH
  slapadd -n 3 -l #{Chef::Config[:file_cache_path]}/root.ldif
  EOH
  action :run
  notifies :start, 'service[slapd]'
end
