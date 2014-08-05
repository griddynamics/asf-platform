# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_jira_ldap
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

jira_ldap_config = node['cicd_infrastructure']['jira']['ldap']

execute "configure ldap" do
    user "root"
    command "mysql -ujira -pchangeit jira < /ldap_configure.sql"
    action :nothing
end

host = node['jira']['apache2']['virtual_host_name']

ruby_block "wait for JIRA" do
     block do
         require "net/https"
         require "uri"
         port = node['jira']['apache2']['ssl']['port']
         path = "secure/SetupApplicationProperties!default.jspa"
         uri = URI.parse("https://#{host}/#{path}")
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         request = Net::HTTP::Get.new(uri.request_uri)
	 node['jira']['attempt_count'].times {
             sleep(node['jira']['sleep_period'])
            break if File.read("/opt/atlassian/jira/logs/catalina.out")
            .include?("You can now access JIRA through your web browser")
         }
     end
 end

ruby_block "configure database" do
    block do
	require "net/https"
	require "uri"
	path = "secure/SetupDatabase.jspa"
	uri = URI("https://#{host}/#{path}")
	req = Net::HTTP::Get.new(uri.path)
	res = Net::HTTP.start(
	    uri.host, 
	    :use_ssl => uri.scheme == 'https', 
	    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
	 https.request(req)
	end
	node['jira']['attempt_count'].times {
             sleep(node['jira']['sleep_period'])
            break if File.read("/opt/atlassian/jira/logs/catalina.out")
            .include?("JIRA has been upgraded to build number")
        }
    end
  action :nothing
end

template "#{node['jira']['work_dir']}/ldap_configure.sql" do
  source 'jira/ldap_configure.sql.erb'
  owner node['jira']['user']
  group node['jira']['group']
  mode 0644
  variables(
    host:         jira_ldap_config['host'],
    port:         jira_ldap_config['port'],
    basedn:       jira_ldap_config['basedn'],
    rootdn:       jira_ldap_config['rootdn'],
    root_pwd:     jira_ldap_config['root_pwd'],
    scheme:       jira_ldap_config['scheme'],
    userdn:       jira_ldap_config['userdn'],
    user_attrs:   jira_ldap_config['user_attrs'],
    groupdn:      jira_ldap_config['groupdn'],
    group_attrs:  jira_ldap_config['group_attrs']
  )
  notifies :restart, 'service[jira]', :delayed
  notifies :run, 'ruby_block[wait for JIRA]', :delayed
  notifies :run, 'ruby_block[configure database]', :delayed
  notifies :run, 'execute[configure ldap]', :delayed
end
