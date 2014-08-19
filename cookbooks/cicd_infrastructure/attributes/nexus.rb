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
override['nexus']['version'] = '2.8.1-01'
override['nexus']['checksum'] = 'b72a9dd6f332b725cd4b5f2aafd6a97eea5fb3b5611f8c046223758a16b5625b'
override['nexus']['external_version'] = '2.8.1'
override['nexus']['bundle_name'] = "#{node['nexus']['name']}-#{node['nexus']['version']}"
override['nexus']['url'] = "http://www.sonatype.org/downloads/nexus-#{node['nexus']['external_version']}-bundle.tar.gz"
override['nexus']['attempt_count'] = 1
override['nexus']['sleep_period'] = 60
override['nexus']['use_chef_vault'] = 'false'
