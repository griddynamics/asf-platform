# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Recipe:: default
#
# Copyright 2014, Grid Dynamics International, Inc.
#

include Opscode::OpenSSL::Password
node.set_unless['postgresql']['password']['postgres'] = secure_password

include_recipe 'jira::server'
include_recipe 'jira::local_database'
