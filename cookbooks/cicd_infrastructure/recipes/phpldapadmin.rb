# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Recipe:: phpldapadmin
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

# Add the EPEL repo
yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
end

# Install phpldapadmin package
package "phpldapadmin"

service 'httpd' do
  action :nothing
end


# Configure phpldapadmin from templates

template "/etc/httpd/conf.d/phpldapadmin.conf" do
  source 'openldap/phpldapadmin.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

template "/etc/phpldapadmin/config.php" do
  source 'openldap/config.php.erb'
  owner 'root'
  group 'apache'
  mode 0640
  notifies :restart, 'service[httpd]'
end