# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Attributes:: dashboard
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

node.default['apache']['default_site_enabled'] = false

default['cicd_infrastructure']['dashboard']['alias'] = '/dashboard'

['jenkins', 'gerrit', 'nexus', 'jira', 'sonar', 'selenium', 'ldap' ].each do |service|
  default['cicd_infrastructure']['dashboard']['services'][service] = {
    'ip' => 'Unavailable',
    'endpoint' => "Unavailable"
  }
end
