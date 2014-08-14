# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Definition:: add_jenkins_global_var
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#


define :add_jenkins_global_var, name: nil, 
		key: nil,
                value: nil do
	ruby_block "add_var_to_jenkins" do
		block do 
			unless params[:name].nil?
				raise 'For adding jenkins global var you should specify key and value' if params[:key].nil? or params[:value].nil?

				require 'rexml/document'
				key = params[:key]
				value = params[:value]
				doc = nil
				jenkins_config_path = File.join(node["jenkins"]["master"]["home"],"config.xml")
				File.open(jenkins_config_path, "r") do |jenkins_config|
					doc = REXML::Document.new(jenkins_config)
					node = doc.root.elements['//hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map']
					if node.nil? # there is no property section, make it
						new_values = "
							<hudson.slaves.EnvironmentVariablesNodeProperty>
								<envVars serialization=\"custom\">
									<unserializable-parents/>
									<tree-map>
										<default>
											<comparator class=\"hudson.util.CaseInsensitiveComparator\"/>
										</default>
										<int>1</int>
										<string>#{key}</string>
										<string>#{value}</string>
									</tree-map>
								</envVars>
							</hudson.slaves.EnvironmentVariablesNodeProperty>
						"
						new_value_part = REXML::Document.new(new_values)
						node = doc.root.elements["//globalNodeProperties"]
						node.add_element(new_value_part)

					else
						# change existing key
						key_element = node.get_elements("string[text()=\"#{key}\"]").first
						unless key_element.nil?
							key_element.next_element.text = value
						else # add new value to list
							[key, value].each do |elem_value|
								new_elem = REXML::Element.new("string")
								new_elem.add_text(elem_value)
								node.add_element(new_elem)
							end		
							int_element = node.elements["int"]
							int_element.text = int_element.text.to_i + 1

						end	
					end	
				end	
			end		

			File.open(jenkins_config_path, "r+") do |jenkins_config|
				jenkins_config << doc
			end unless doc.nil?	
		end
	end
end
