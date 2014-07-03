# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: nexus
#
# Copyright 2014, Grid Dynamics International, Inc.
#

override['nexus']['cli']['ssl']['verify'] = false
override['nexus']['app_server_proxy']['use_self_signed'] = true
override['nexus']['version'] = '2.8.1'
