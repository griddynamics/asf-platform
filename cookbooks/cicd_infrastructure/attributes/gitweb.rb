# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: gitweb
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

default['gitweb']['auth']['type'] = 'LDAP'
default['gitweb']['proxy']['port']['http'] = '8000'
default['gitweb']['repository_dir'] = "#{node['gerrit']['install_dir']}/git"
