# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_gerrit_jenkins
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

# Setup root user
gerrit_ssh_dir = "#{node['gerrit']['home']}/.ssh"

directory gerrit_ssh_dir do
  action :create
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0755
end

ssh_keys gerrit_ssh_dir do
  user node['gerrit']['user']
  group node['gerrit']['group']
  action :create
end

template "#{gerrit_ssh_dir}/config" do
  source 'integration/gerrit/ssh_config.erb'
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0644
end

ruby_block 'add_root_user' do
  block do
    require 'mysql'
    db = Mysql.new(node['gerrit']['database']['host'],
                   node['gerrit']['database']['username'],
                   node['gerrit']['database']['password'],
                   node['gerrit']['database']['name'])
    db.query("INSERT IGNORE INTO `account_external_ids` \
      VALUES (1,'root@localhost',NULL,'username:root')")
    db.query("INSERT IGNORE INTO `account_group_members` \
      VALUES (1,1)")
    db.query("INSERT IGNORE INTO `account_group_members_audit` \
      VALUES (1,NULL,NULL,1,NULL,1)")
    db.query("INSERT IGNORE INTO `account_id` \
      VALUES (1)")
    db.query("INSERT IGNORE INTO `account_ssh_keys` \
      VALUES ('#{File.read("#{gerrit_ssh_dir}/id_rsa.pub")}','Y',1,1)")
    db.query("INSERT IGNORE INTO `accounts` \
      VALUES (NULL, 'root', NULL, NULL, 'N', NULL, NULL, NULL, NULL, 25, \
        'N', 'N', 'Y', 'N', NULL, 'Y', 'N', NULL,
        '#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}', 1)")
    db.close
  end
  retries 5
  retry_delay 30
end

# Setup user for jenkins gerrit-trigger
jenkins_pubkey = node['cicd_infrastructure']['gerrit']['jenkins_pubkey']
jenkins_host = node['cicd_infrastructure']['gerrit']['jenkins_host']

ruby_block 'add_jenkins_user' do
  block do
    require 'mysql'
    db = Mysql.new(node['gerrit']['database']['host'],
                   node['gerrit']['database']['username'],
                   node['gerrit']['database']['password'],
                   node['gerrit']['database']['name'])
    db.query("INSERT IGNORE INTO `account_external_ids` \
      VALUES (2,'jenkins@#{jenkins_host}',NULL,'username:jenkins')")
    db.query("INSERT IGNORE INTO `account_group_members` \
      VALUES (2,1)")
    db.query("INSERT IGNORE INTO `account_group_members_audit` \
      VALUES (1,NULL,NULL,2,NULL,1)")
    db.query("INSERT IGNORE INTO `account_id` \
      VALUES (2)")
    db.query("INSERT IGNORE INTO `account_ssh_keys` \
      VALUES ('#{jenkins_pubkey}','Y',2,1)")
    db.query("INSERT IGNORE INTO `accounts` \
      VALUES (NULL, 'JenkinsCI', NULL, NULL, 'N', NULL, NULL, NULL, NULL, 25, \
        'N', 'N', 'Y', 'N', NULL, 'Y', 'N', NULL,
        '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}', 2)")
    db.close
  end
  retries 5
  retry_delay 30
end

template '/tmp/project.config' do
  source 'gerrit/project.config.erb'
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0644
end

bash 'Configure gerrit repos' do
  user node['gerrit']['user']
  cwd '/tmp'
  code <<-EOH
  mkdir gerrit-config
  cd gerrit-config
  git init
  git remote add origin \
    ssh://root@localhost:#{node['gerrit']['port']}/All-Projects
  git fetch origin refs/meta/config:refs/remotes/origin/meta/config
  git checkout meta/config
  cp /tmp/project.config /tmp/gerrit-config/project.config
  git config user.email root@localhost
  git config user.name root
  git add project.config
  git commit -m 'Updated permissions'
  git push origin meta/config:meta/config
  EOH
end
