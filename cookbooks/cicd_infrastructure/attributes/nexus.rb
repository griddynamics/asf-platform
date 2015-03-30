# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: nexus
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

override['nexus']['cli']['ssl']['verify'] = false
override['nexus']['app_server_proxy']['use_self_signed'] = true
override['nexus']['version'] = '2.10.0-02'
override['nexus']['checksum'] = '730442be2ca4918b44a69b98bb62abfcbf8ce8f997385349510dd807c1bf88d6'
override['nexus']['external_version'] = '2.10.0'
override['nexus']['bundle_name'] = "#{node['nexus']['name']}-#{node['nexus']['version']}"
override['nexus']['url'] = "http://download.sonatype.com/nexus/oss/nexus-#{node['nexus']['version']}-bundle.tar.gz"
override['nexus']['attempt_count'] = 1
override['nexus']['sleep_period'] = 60
override['nexus']['use_chef_vault'] = 'false'
