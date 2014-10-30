# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: sonar
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

include_recipe 'java'
include_recipe 'sonar'
include_recipe 'sonar::database_mysql'
include_recipe 'postfix'
