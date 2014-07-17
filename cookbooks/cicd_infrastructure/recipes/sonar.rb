# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: sonar
#
# Copyright 2014, Grid Dynamics International, Inc.
#

include_recipe 'java'
include_recipe 'sonar'
include_recipe 'sonar::database_mysql'

#install LDAP plugin

sonar_plugin 'sonar-ldap-plugin' do
    version '1.4'
end

template 'sonar.properties.ldap' do
   path "#{node[:sonar][:dir]}/conf/sonar.properties.ldap"
   source '/sonar/sonar.properties.ldap.erb'
   owner 'root'
   group 'root'
   mode 0644
end

execute "Add LDAP properties to sonar.properties file" do
  user "root"
  command "cat #{node[:sonar][:dir]}/conf/sonar.properties.ldap >> #{node[:sonar][:dir]}/conf/sonar.properties"
  notifies :restart, 'service[sonar]'
end
