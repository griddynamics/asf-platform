# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: openldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

node.set['openldap']['basedn'] = 'dc=asf,dc=griddynamics,dc=com'
node.set['openldap']['manage_ssl'] = false
node.set['openldap']['rootpw'] = 'password'

default['openldap']['server'] = 'localhost'
default['openldap']['users'] = [
  {
    'username' => 'sample',
    'password' => 'samplepassword',
    'group' => 'developers'
  },
  {
    'username' => 'jenkins-ci-bot',
    'password' => 'jenkin$CiB0t',
    'group' => 'developers'
  }
]
