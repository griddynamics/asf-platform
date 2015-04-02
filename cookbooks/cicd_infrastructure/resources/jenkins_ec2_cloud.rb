# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Resource:: jenkins_ec2_cloud
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

actions :configure
default_action :configure

attribute :regionName, kind_of: String, name_attribute: true
attribute :accessId, kind_of: String
attribute :secretKey, kind_of: String
attribute :privateKey, kind_of: String
attribute :instanceCap, kind_of: String
attribute :region, kind_of: String
attribute :templates, kind_of: Array
