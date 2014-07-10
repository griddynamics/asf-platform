# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: gerrit
#
# Copyright 2014, Grid Dynamics International, Inc.
#

default['gerrit']['version'] = "2.8.6"
default['gerrit']['auth']['registerEmailPrivateKey'] = 'gerrit'
default['gerrit']['auth']['restTokenPrivateKey'] = 'gerrit'
