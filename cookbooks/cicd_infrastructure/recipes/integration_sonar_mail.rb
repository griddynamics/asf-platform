# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: integration_sonar_mail
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

service 'sonar' do
  action :nothing
end

sonar_credentials = node['cicd_infrastructure']['sonar']['credentials']

ruby_block "wait for Sonar" do
  block do
    10.times {
      sleep(60)
      break if File.read("#{node['sonar']['dir']}/logs/sonar.log")
      .include?("Start components done")
    }
  end
end

node['cicd_infrastructure']['sonar']['mail'].each do |key, value|
  ruby_block "set sonar property #{key}:#{value}" do
    block do
      uri = URI.parse("http://localhost:9000")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new("/api/properties?id=email.#{key}&value='#{value}'")
      request.basic_auth sonar_credentials['username'], sonar_credentials['password']
      response = http.request(request)
    end
    notifies :restart, "service[sonar]"
  end
end
