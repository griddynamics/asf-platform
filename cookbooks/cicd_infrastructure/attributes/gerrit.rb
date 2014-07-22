# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: gerrit
#
# Copyright 2014, Grid Dynamics International, Inc.
#

default['gerrit']['version'] = "2.8.6"

if node['cloud']
  case node['cloud']['provider']
  when "ec2"
    default['gerrit']['hostname'] = node['cloud']['public_hostname']
  when "rackspace"
    default['gerrit']['hostname'] = node['cloud']['private_hostname']
  end
end

default['gerrit']['canonicalWebUrl'] = "http://#{node['gerrit']['hostname']}/"

default['gerrit']['auth']['registerEmailPrivateKey'] = 'gerrit'
default['gerrit']['auth']['restTokenPrivateKey'] = 'gerrit'
default['gerrit']['auth']['type'] = 'LDAP'

default['gerrit']['ldap']['server'] = 'ldap://localhost'
default['gerrit']['ldap']['accountBase'] = 'ou=people,dc=example,dc=com'
default['gerrit']['ldap']['accountPattern'] = '(&(objectClass=inetOrgPerson)(uid=${username}))'
default['gerrit']['ldap']['accountFullName'] = 'displayName'
