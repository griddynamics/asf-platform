# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: openldap
#
# Copyright 2014, Grid Dynamics International, Inc.
#

node.set['openldap']['basedn'] = 'dc=example,dc=com'
node.set['openldap']['manage_ssl'] = false
node.set['openldap']['rootpw'] = '{SSHA}d2BamRTgBuhC6SxC0vFGWol31ki8iq5m'

default['openldap']['server'] = 'localhost'
default['openldap']['users'] = [
  {
    'username' => 'sample',
    'password' => 'samplepassword'
  }
]
