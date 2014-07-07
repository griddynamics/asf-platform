# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: jenkins
#
# Copyright 2014, Grid Dynamics International, Inc.
#
override['jenkins']['master']['version'] = '1.554.2 LTS'
override['jenkins']['master']['install_method'] = 'war'
