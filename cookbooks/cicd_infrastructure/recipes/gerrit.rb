# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: default
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

include_recipe 'gerrit::default'
include_recipe 'gitweb'

gerrit_init = resources(execute: 'gerrit-init')
node['gerrit']['plugins'].each do |plugin|
    gerrit_init.command gerrit_init.command << " --install-plugin #{plugin}"
end
