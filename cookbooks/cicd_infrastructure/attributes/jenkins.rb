# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: jenkins
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

override['jenkins']['master']['version'] = '1.554.2'
override['jenkins']['master']['install_method'] = 'war'
override['jenkins']['master']['source'] =
    "#{node['jenkins']['master']['mirror']}/war-stable/#{node['jenkins']['master']['version'] || 'latest'}/jenkins.war"

default['cicd_infrastructure']['jenkins']['cfg_provider']['settings_id'] = 'org.jenkinsci.plugins.configfiles.maven.GlobalMavenSettingsConfig1234567890123'

