# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: nexus
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

Chef::Config[:file_cache_path] = '/var/chef/cache/'

include_recipe 'nexus::default'

nexus_config = node['cicd_infrastructure']['nexus']

service 'nexus' do
  action :nothing
end

template '/nexus/sonatype-work/nexus/conf/nexus.xml' do
  source 'nexus/nexus.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    buid_main_repo_id:         nexus_config['repo']['build']['main']['id'],
    buid_main_repo_name:       nexus_config['repo']['build']['main']['name'],
    buid_main_repo_policy:     nexus_config['repo']['build']['main']['policy'],
    buid_main_repo_ttl:        nexus_config['repo']['build']['main']['ttl'],
    buid_feature_repo_id:         nexus_config['repo']['build']['feature']['id'],
    buid_feature_repo_name:       nexus_config['repo']['build']['feature']['name'],
    buid_feature_repo_policy:     nexus_config['repo']['build']['feature']['policy'],
    buid_feature_repo_ttl:        nexus_config['repo']['build']['feature']['ttl'],
    promote_repo_id:      nexus_config['repo']['promote']['id'],
    promote_repo_name:    nexus_config['repo']['promote']['name'],
    promote_repo_policy:  nexus_config['repo']['promote']['policy'],
    promote_repo_ttl:     nexus_config['repo']['promote']['ttl']
  )
  notifies :restart, 'service[nexus]'
end
