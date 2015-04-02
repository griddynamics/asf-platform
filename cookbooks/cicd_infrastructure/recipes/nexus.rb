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
include_recipe 'iptables::default'

iptables_rule 'allow_private_ips'
iptables_rule 'allow_nexus' do
  source 'nexus/allow_nexus.erb'
end

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
    buid_main_repo_id:		nexus_config['repo']['build']['main']['id'],
    buid_main_repo_name:	nexus_config['repo']['build']['main']['name'],
    buid_main_repo_policy:	nexus_config['repo']['build']['main']['policy'],
    buid_main_repo_ttl:		nexus_config['repo']['build']['main']['ttl'],
    buid_main_min_snapshots:	nexus_config['repo']['build']['main']['snapshots'],
    buid_feature_repo_id:	nexus_config['repo']['build']['feature']['id'],
    buid_feature_repo_name:	nexus_config['repo']['build']['feature']['name'],
    buid_feature_repo_policy:	nexus_config['repo']['build']['feature']['policy'],
    buid_feature_repo_ttl:	nexus_config['repo']['build']['feature']['ttl'],
    buid_feature_min_snapshots:	nexus_config['repo']['build']['feature']['snaphots'],
    build_group_repo_id:	nexus_config['repo']['build']['group']['id'],
    build_group_repo_name:	nexus_config['repo']['build']['group']['name'],
    promote_repo_id:		nexus_config['repo']['promote']['id'],
    promote_repo_name:		nexus_config['repo']['promote']['name'],
    promote_repo_policy:	nexus_config['repo']['promote']['policy'],
    promote_repo_ttl:		nexus_config['repo']['promote']['ttl'],
    promote_repo_min_snapshots:	nexus_config['repo']['promote']['snapshots'],
    build_promoted_group_repo_id:   nexus_config['repo']['build']['promote']['group']['id'],
    build_promoted_group_repo_name: nexus_config['repo']['build']['promote']['group']['name'],
    gd_repo_id:        nexus_config['repo']['gd']['id'],
    gd_repo_name:      nexus_config['repo']['gd']['name'],
    gd_repo_policy:    nexus_config['repo']['gd']['policy'],
    gd_repo_location:  nexus_config['repo']['gd']['location']
  )
  notifies :restart, 'service[nexus]'
end
