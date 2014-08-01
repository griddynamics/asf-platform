# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: jira
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

node.set['jira']['jvm']['minimum_memory']  = '768m'
node.set['jira']['jvm']['maximum_memory']  = '1536m'
node.set['jira']['jvm']['maximum_permgen'] = '768m'
node.set['jira']['jvm']['java_opts'] = '-Datlassian.plugins.enable.wait=300'

if node['cloud']
  node.set['jira']['apache2']['virtual_host_alias'] =
    node['cloud']['public_hostname']
  node.set['jira']['apache2']['virtual_host_name'] =
    node['cloud']['public_hostname']
end
