# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: jenkins
#
# Copyright 2014, Grid Dynamics International, Inc.
#
override['jenkins']['master']['version'] = '1.554.2'
override['jenkins']['master']['install_method'] = 'war'
override['jenkins']['master']['source'] =
    "#{node['jenkins']['master']['mirror']}/war-stable/#{node['jenkins']['master']['version'] || 'latest'}/jenkins.war"
