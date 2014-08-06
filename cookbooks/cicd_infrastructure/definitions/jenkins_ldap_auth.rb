# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Definition:: jenkins_ldap_auth
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#


define :jenkins_ldap_auth, name: nil, 
		    auth:       nil,
		    server:     nil,
		    port:       nil,
		    basedn:     nil,
		    userdn:     nil,
		    user_id:    nil,
		    rootdn:     nil,
		    root_pwd:   nil do
	ruby_block "jenkins_ldap_auth" do
		block do 
			unless params[:name].nil?
				require 'rexml/document'
				auth = params[:auth]
				server = params[:server]
				port = params[:port]
				basedn = params[:basedn]
				userdn = params[:userdn]
				user_id = params[:user_id]
				rootdn = params[:rootdn]
				root_pwd = Base64.encode64(params[:root_pwd])
				doc = nil
				jenkins_config_path = File.join(node["jenkins"]["master"]["home"],"config.xml")
				File.open(jenkins_config_path, "r") do |jenkins_config|
					doc = REXML::Document.new(jenkins_config)
					doc.root.delete_element(doc.root.elements['//authorizationStrategy'])
					doc.root.delete_element(doc.root.elements['//securityRealm'])
					authorizationStrategy = "<authorizationStrategy class=\"hudson.security.FullControlOnceLoggedInAuthorizationStrategy\"/>"
					securityRealm = "
						  <securityRealm class=\"hudson.security.LDAPSecurityRealm\" plugin=\"ldap@1.6\">
						    <server>ldap://#{ server }:#{ port }</server>
						    <rootDN>#{ basedn }</rootDN>
						    <inhibitInferRootDN>false</inhibitInferRootDN>
						    <userSearchBase>#{ userdn }</userSearchBase>
						    <userSearch>#{ user_id }</userSearch>
						    <managerDN>#{ rootdn }</managerDN>
						    <managerPassword>#{ root_pwd }</managerPassword>
						    <disableMailAddressResolver>false</disableMailAddressResolver>
						  </securityRealm>
					"
					[authorizationStrategy, securityRealm].each do |elem|
						new_elem = REXML::Document.new(elem)
						doc.root.add_element(new_elem)
					end		

				end	
			end		

			File.open(jenkins_config_path, "r+") do |jenkins_config|
				jenkins_config << doc
			end unless doc.nil?	
		end
	end
end
