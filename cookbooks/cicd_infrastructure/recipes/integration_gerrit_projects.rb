# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_gerrit_projects
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

['Open-Projects', 'Private-Projects'].each do |prj_name|
  bash "create gerrit-project #{prj_name}" do
    user node['gerrit']['user']
    code <<-EOH
    ssh -p #{node['gerrit']['port']} root@localhost\
    gerrit create-project\
    --permissions-only\
    --name #{prj_name}.git
    EOH
    not_if {
      File.directory?("#{node['gerrit']['home']}/review/git/#{prj_name}.git")
    }
  end
end

['All-Projects', 'Open-Projects', 'Private-Projects'].each do |prj_name|
  directory "/tmp/#{prj_name}" do
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0755
    action :delete
    recursive true
  end

  git "/tmp/#{prj_name}" do
    repository "#{node['gerrit']['home']}/review/git/#{prj_name}.git"
    user node['gerrit']['user']
    group node['gerrit']['group']
    action :checkout
  end


  template "/tmp/#{prj_name}/project.config" do
    source "gerrit/project-#{prj_name}.config.erb"
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0644
  end

  file "/tmp/#{prj_name}/groups" do
    action :create_if_missing
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0644
  end

  ruby_block "add global:Registered-Users to groups" do
    block do
      file = Chef::Util::FileEdit.new("/tmp/#{prj_name}/groups")
      file.insert_line_if_no_match(
        '/global:Registered-Users/',
        'global:Registered-Users Registered Users')
      file.write_file
    end
    not_if { prj_name == 'Private-Projects' }
  end

  bash "push updated gerrit #{prj_name} repo config" do
    user node['gerrit']['user']
    cwd "/tmp/#{prj_name}"
    code <<-EOH
    git config user.email root@localhost
    git config user.name root
    git add -A
    git commit -m 'Updated permissions'
    git push -q origin HEAD:refs/meta/config
    EOH
  end
end
