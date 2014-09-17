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
    jbehave_framework_repo_id:        nexus_config['repo']['jbehave']['id'],
    jbehave_framework_repo_name:      nexus_config['repo']['jbehave']['name'],
    jbehave_framework_repo_policy:    nexus_config['repo']['jbehave']['policy'],
    jbehave_framework_repo_location:  nexus_config['repo']['jbehave']['location'],
    jbehave_framework_repo_username:  nexus_config['repo']['jbehave']['username'],
    jbehave_framework_repo_password:  nexus_config['repo']['jbehave']['password'],
    use_jbehave_proxy:		nexus_config['repo']['jbehave']['use']
  )
  notifies :restart, 'service[nexus]'
end
