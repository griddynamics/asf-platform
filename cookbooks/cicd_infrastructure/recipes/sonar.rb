# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: sonar
#
# Copyright 2014, Grid Dynamics International, Inc.
#

include_recipe 'java'
include_recipe 'sonar'
include_recipe 'sonar::database_mysql'
