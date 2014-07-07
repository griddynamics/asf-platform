# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: openldap_new_users
#
# Copyright 2014, Grid Dynamics International, Inc.
#

node['openldap']['users'].each do |record|
  template "#{Chef::Config[:file_cache_path]}/user_#{record}.ldif" do
    source 'openldap/root.ldif.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      basedn: node['ca_openldap']['basedn'],
      username: record.username,
      password: record.password
    )
  end

  bash 'create ldap_user[#{record.username}]' do
    user 'root'
    code <<-EOH
    ldapadd -x \
      -w #{node['ca_openldap']['rootpassword']} \
      -D "#{node['ca_openldap']['rootdn']},#{node['ca_openldap']['basedn']}" \
      -f #{Chef::Config[:file_cache_path]}/user_#{record}.ldif
    EOH
  end
end
