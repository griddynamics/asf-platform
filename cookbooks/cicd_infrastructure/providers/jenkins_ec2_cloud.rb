# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Provider:: jenkins_ec2_cloud
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#
require 'rexml/document'

use_inline_resources

ec2Template = "
        <hudson.plugins.ec2.SlaveTemplate>
          <ami>%{ami}</ami>
          <description>%{description}</description>
          <zone>%{zone}</zone>
          <securityGroups>%{securityGroups}</securityGroups>
          <remoteFS>%{remoteFS}</remoteFS>
          <type>%{type}</type>
          <labels>%{labels}</labels>
          <mode>%{mode}</mode>
          <initScript>%{initScript}</initScript>
          <tmpDir>/tmp</tmpDir>
          <userData>%{userData}</userData>
          <numExecutors>%{numExecutors}</numExecutors>
          <remoteAdmin>%{remoteAdmin}</remoteAdmin>
          <jvmopts>%{jvmopts}</jvmopts>
          <subnetId>%{subnetId}</subnetId>
          <idleTerminationMinutes>%{idleTerminationMinutes}</idleTerminationMinutes>
          <iamInstanceProfile></iamInstanceProfile>
          <useEphemeralDevices>%{useEphemeralDevices}</useEphemeralDevices>
          <customDeviceMapping>%{customDeviceMapping}</customDeviceMapping>
          <instanceCap>%{instanceCap}</instanceCap>
          <stopOnTerminate>%{stopOnTerminate}</stopOnTerminate>
          <tags>
            <hudson.plugins.ec2.EC2Tag>
              <name>Name</name>
              <value>jenkins-slave</value>
            </hudson.plugins.ec2.EC2Tag>
          </tags>
          <usePrivateDnsName>false</usePrivateDnsName>
          <associatePublicIp>false</associatePublicIp>
          <useDedicatedTenancy>false</useDedicatedTenancy>
          <amiType class=\"hudson.plugins.ec2.UnixData\">
            <rootCommandPrefix></rootCommandPrefix>
            <sshPort>22</sshPort>
          </amiType>
          <launchTimeout>%{launchTimeout}</launchTimeout>
        </hudson.plugins.ec2.SlaveTemplate>
"

action :configure do
  ruby_block 'jenkins_ec2_cloud' do
    Chef::Log.info "Add new cloud configuration: #{new_resource.region}"
    block do
      accessId = new_resource.accessId
      secretKey = new_resource.secretKey
      privateKey = new_resource.privateKey
      instanceCap = new_resource.instanceCap
      region = new_resource.region
      templates = new_resource.templates
      doc = nil
      jenkins_config_path = ::File.join(node['jenkins']['master']['home'], 'config.xml')
      ::File.open(jenkins_config_path, 'r') do |jenkins_config|
        doc = REXML::Document.new(jenkins_config)
        doc.root.delete_element("/hudson/clouds/*[accessId/text()='#{ accessId }']")
        ec2Templates = ''
        templates.each do |template|
          template = template.inject({}) do |memo, (k, v)|
            memo[k.to_sym] = v.nil? ? '' : v.encode(:xml => :text)
            memo
          end
          ec2Templates += ec2Template % template.merge({ :instanceCap => instanceCap })
        end
        ec2Cloud = "
 <hudson.plugins.ec2.EC2Cloud plugin=\"ec2@1.24\">
 <name>ec2-#{ region }</name>
 <accessId>#{ accessId }</accessId>
 <secretKey>#{ secretKey }</secretKey>
 <privateKey>
<privateKey>#{ privateKey }</privateKey>
 </privateKey>
 <instanceCap>#{ instanceCap }</instanceCap>
 <templates>
#{ ec2Templates }
 </templates>
 <region>#{ region }</region>
 </hudson.plugins.ec2.EC2Cloud>"

        new_elem = REXML::Document.new(ec2Cloud)
        doc.root.elements['clouds'].add_element(new_elem)
        doc.root.elements['mode'].text = 'EXCLUSIVE'
        doc.root.elements['label'].text = 'master'
      end

      ::File.open(jenkins_config_path, 'r+') do |jenkins_config|
        jenkins_config << doc
      end unless doc.nil?
      new_resource.updated_by_last_action(true)
    end
  end
end
