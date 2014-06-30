# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: jira
#
# Copyright 2014, Grid Dynamics International, Inc.
#

default['jira']['jvm']['minimum_memory']  = '256m'
default['jira']['jvm']['maximum_memory']  = '768m'
default['jira']['jvm']['maximum_permgen'] = '256m'
default['jira']['jvm']['java_opts'] = '-Datlassian.plugins.enable.wait=300'

if node['cloud']
    override['jira']['apache2']['virtual_host_alias'] =
        node['cloud']['public_hostname']
    override['jira']['apache2']['virtual_host_name'] =
        node['cloud']['public_hostname']
end
