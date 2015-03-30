# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Definition:: wait_for_sonar
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

define :wait_for_sonar, name: nil, sonar_host: nil, sonar_port: nil, attempts: nil do
  ruby_block 'wait_for_sonar' do
    block do
      sonar_host = params[:sonar_host]
      sonar_port = params[:sonar_port]
      attempts = params[:attempts]

      def retry_server(host, port, message, attempts)
        Chef::Log.info("Waiting for server: #{message}")
        sleep(10)
        wait_for_server(host, port, attempts - 1)
      end

      def wait_for_server(host, port, attempts)
        fail 'Timed out waiting for server' if attempts == 0
        uri = URI("http://#{host}:#{port}/api/server?format=json")
        begin
          response = Net::HTTP.get(uri)
          status = JSON.parse(response)['status']
          retry_server("status: #{status}", attempts) unless status == 'UP'
        rescue => e
          retry_server(host, port, e.message, attempts)
        end
      end

      wait_for_server(sonar_host, sonar_port, attempts)
    end
  end
end
