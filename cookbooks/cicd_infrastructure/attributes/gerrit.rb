# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: gerrit
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

default['gerrit']['version'] = "2.9"

if node['cloud']
  case node['cloud']['provider']
  when "ec2"
    default['gerrit']['hostname'] = node['cloud']['public_ipv4']
  when "rackspace"
    default['gerrit']['hostname'] = node['cloud']['public_ipv4']
  end
end

default['gerrit']['canonicalWebUrl'] = "http://#{node['gerrit']['hostname']}/"

default['gerrit']['auth']['registerEmailPrivateKey'] = 'gerrit'
default['gerrit']['auth']['restTokenPrivateKey'] = 'gerrit'
default['gerrit']['sendemail']['enable'] = 'false'

default['gerrit']['plugins'] = %w(
    commit-message-length-validator
    download-commands
    replication
    reviewnotes
)
