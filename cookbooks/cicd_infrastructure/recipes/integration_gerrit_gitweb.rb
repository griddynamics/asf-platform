# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_gerrit_gitweb
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

package 'gitweb' do
	action :install
end

execute "Add gitweb to gerrit config" do
	command "git config --file /var/gerrit/review/etc/gerrit.config gitweb.cgi /var/www/git/gitweb.cgi"
	user node['gerrit']['user']
end
