# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: openldap
#
# Copyright 2014, Grid Dynamics International, Inc.
#

node.set['openldap']['basedn'] = 'dc=example,dc=com'
node.set['openldap']['manage_ssl'] = false
node.set['openldap']['rootpw'] = 'password'

default['openldap']['server'] = 'localhost'
default['openldap']['users'] = [
  {
    'username' => 'sample',
    'password' => 'samplepassword'
  }
]
