# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: openldap
#
# Copyright 2014, Grid Dynamics International, Inc.
#

user 'openldap' do
  action :create
  gid 'users'
  shell '/bin/bash'
end

group 'openldap' do
  action :create
  members ['openldap']
end

include_recipe 'openldap::server'
include_recipe 'openldap::auth'
include_recipe 'cicd_infrastructure::openldap_init_root'
include_recipe 'cicd_infrastructure::openldap_new_users'

unless node['platform'].eql?('ubuntu')
  ldap_client = resources(package: 'ldap-utils')
  ldap_client.name('openldap-clients')
  ldap_client.package_name('openldap-clients')
  ldap_client.action(:upgrade)

  db_util = resources(package: 'db4.2-util')
  db_util.action(:nothing)

  ldap_server = resources(package: 'slapd')
  ldap_server.name('openldap-servers')
  ldap_server.package_name('openldap-servers')
  ldap_server.action(:upgrade)

  libpam_ldap = resources(package: 'libpam-ldap')
  libpam_ldap.name('pam_ldap')
  libpam_ldap.package_name('pam_ldap')
  libpam_ldap.action(:upgrade)

  libnss_ldap = resources(package: 'libnss-ldap')
  libnss_ldap.name('nss-pam-ldapd')
  libnss_ldap.package_name('nss-pam-ldapd')
  libnss_ldap.action(:upgrade)

  ldap_conf = resources(template: "#{node['openldap']['dir']}/ldap.conf")
  ldap_conf.source 'openldap/ldap.conf.erb'
  ldap_conf.cookbook('cicd_infrastructure')
end
