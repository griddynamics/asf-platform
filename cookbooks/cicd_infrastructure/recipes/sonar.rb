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
include_recipe 'sonarqube'
include_recipe 'postfix'
include_recipe 'iptables'

iptables_rule 'allow_private_ips'
iptables_rule 'allow_sonar' do
  source 'sonar/allow_sonar.erb'
end
