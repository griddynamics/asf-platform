# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: default
#
# Copyright 2014, Grid Dynamics International, Inc.
#

include_recipe 'java::default'
include_recipe 'jira::default'

ruby_block "wait for JIRA" do
    block do
        require "net/https"
        require "uri"

        host = node['jira']['apache2']['virtual_host_name']
        port = node['jira']['apache2']['ssl']['port']
        path = "secure/SetupApplicationProperties!default.jspa"

        uri = URI.parse("https://#{host}:#{port}/#{path}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)

        10.times {
            |x| Chef::Log.info("Trying to connect... #{10 - x} retries remain")
            break if http.request(request).code.eql?('200')
            sleep(30)
        }
    end
end

