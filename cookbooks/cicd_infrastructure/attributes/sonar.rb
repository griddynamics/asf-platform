# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: sonarqube
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

override['sonarqube']['version'] = '4.5.1'
override['sonarqube']['checksum'] = '0c29f717266c4b03c471184ca4ffd95e5efa12f8c3ca02c971bffc5ff6e94417'

default['sonarqube']['dir'] = "/opt/sonarqube-#{node['sonarqube']['version']}"
default['sonarqube']['plugins_repo'] = 'http://repository.codehaus.org/org/codehaus/sonar-plugins'
default['sonarqube']['plugins_dir'] = 'extensions/plugins'
default['sonarqube']['downloads_dir'] = 'extensions/downloads'
