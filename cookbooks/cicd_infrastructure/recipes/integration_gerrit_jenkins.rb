# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_gerrit_jenkins
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

jenkins_pubkey = node['cicd_infrastructure']['gerrit']['jenkins_pubkey']

bash 'add_jenkins_user' do
  user node['gerrit']['user']
  code <<-EOH
  echo #{jenkins_pubkey} | ssh -p #{node['gerrit']['port']} root@localhost\
  gerrit create-account\
  --group "'Administrators'"\
  --full-name JenkinsCI\
  --email jenkins-asf@griddynamics.com\
  --http-password jenkins\
  --ssh-key - jenkins
  EOH
  action :nothing
end
