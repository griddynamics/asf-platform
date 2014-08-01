# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: nexus
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

override['nexus']['cli']['ssl']['verify'] = false
override['nexus']['app_server_proxy']['use_self_signed'] = true
override['nexus']['version'] = '2.8.1'
