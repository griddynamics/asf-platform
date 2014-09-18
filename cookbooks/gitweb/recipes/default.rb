# Encoding: utf-8
#
# Cookbook Name:: gitweb
# Recipe:: default
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

include_recipe 'git'
include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_cgi'

if node['gitweb']['auth']['type'] == 'LDAP'
  include_recipe 'apache2::mod_ldap'
  include_recipe 'apache2::mod_authnz_ldap'
end

package 'gitweb' do
  action :install
end

template '/etc/gitweb.conf' do
  owner  'root'
  group  'root'
  mode   '0644'
  variables node['gitweb']
  notifies :reload, resources(:service => 'apache2')
end

if node['gitweb']['theme']
  git '/var/www/git/theme' do
    repository node['gitweb']['theme']
    reference 'master'
    action :sync
  end
end

apache_site 'default' do
  enable false
end

if node['gitweb']['ssl']
  include_recipe "apache2::mod_ssl"

  ssl_certfile_path = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  ssl_keyfile_path  = '/etc/ssl/private/ssl-cert-snakeoil.key'

  if node['gitweb']['ssl_certificate']
    ssl_certificate node['gitweb']['ssl_certificate']
    ssl_certfile_path = node['ssl_certificates']['path'] + "/" + node['gitweb']['ssl_certificate'] + ".crt"
    ssl_keyfile_path  = node['ssl_certificates']['path'] + "/" + node['gitweb']['ssl_certificate'] + ".key"
    ssl_cabundle_path = node['ssl_certificates']['path'] + "/" + node['gitweb']['ssl_certificate'] + ".ca-bundle"
  end
end

web_app 'gitweb' do
  server_name node['gitweb']['hostname']
  server_aliases []
  docroot '/var/www/git'
  template 'web_app.conf.erb'
  if node['gitweb']['ssl']
    ssl_certfile         ssl_certfile_path
    ssl_keyfile          ssl_keyfile_path
    ssl_cabundle_used    ::File::exist?(ssl_cabundle_path)
    ssl_cabundle         ssl_cabundle_path
  end
end
