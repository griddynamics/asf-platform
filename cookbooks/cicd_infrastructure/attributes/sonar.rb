# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Attributes:: sonar
#
# Copyright 2014, Grid Dynamics International, Inc.
#

override['sonar']['version'] = '3.7.4'
default['ldap']['realm'] = 'mydomain.com'
default['ldap']['security']['realm'] = 'LDAP'
default['ldap']['server'] = 'localhost'
