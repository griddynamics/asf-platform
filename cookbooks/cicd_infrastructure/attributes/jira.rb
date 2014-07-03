# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: jira
#
# Copyright 2014, Grid Dynamics International, Inc.
#

node.set['jira']['jvm']['minimum_memory']  = '768m'
node.set['jira']['jvm']['maximum_memory']  = '1024m'
node.set['jira']['jvm']['maximum_permgen'] = '768m'
node.set['jira']['jvm']['java_opts'] = '-Datlassian.plugins.enable.wait=300'

if node['cloud']
    node.set['jira']['apache2']['virtual_host_alias'] =
        node['cloud']['public_hostname']
    node.set['jira']['apache2']['virtual_host_name'] =
        node['cloud']['public_hostname']
end
