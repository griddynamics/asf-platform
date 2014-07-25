# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Attributes:: default
#
# Copyright 2014, Grid Dynamics International, Inc.
#

default['cicd_infrastructure']['jenkins']['plugins'] = [
    'mailer',
    'openid4java',
    'openid',
    'promoted-builds',
    'credentials',
    'ssh-credentials',
    'ssh-agent',
    'git-client',
    'scm-api',
    'git',
    'parameterized-trigger',
    'gerrit-trigger'
]
default['cicd_infrastructure']['jenkins']['gerrit-trigger']['host'] = 'localhost'
default['cicd_infrastructure']['jenkins']['gerrit-trigger']['ssh_port'] = '29418'
default['cicd_infrastructure']['jenkins']['gerrit-trigger']['http_port'] = '80'

default['cicd_infrastructure']['gerrit']['jenkins_host'] = nil
default['cicd_infrastructure']['gerrit']['jenkins_pubkey'] = nil

default['cicd_infrastructure']['nexus']['auth'] = 'LDAP'
default['cicd_infrastructure']['nexus']['ldap']['host'] = 'localhost'
default['cicd_infrastructure']['nexus']['ldap']['port'] = '389'
default['cicd_infrastructure']['nexus']['ldap']['basedn'] = 'dc=example,dc=com'
default['cicd_infrastructure']['nexus']['ldap']['rootdn'] = "cn=admin,#{node['cicd_infrastructure']['nexus']['ldap']['basedn']}"
default['cicd_infrastructure']['nexus']['ldap']['root_pwd'] = 'password'
default['cicd_infrastructure']['nexus']['ldap']['scheme'] = 'simple'
default['cicd_infrastructure']['nexus']['ldap']['userdn'] = 'ou=people'
default['cicd_infrastructure']['nexus']['ldap']['user_attrs'] = {
  'userId' => 'uid',
  'userPwd' => 'userPassword',
  'objClass' => 'inetOrgPerson',
  'mail' => 'mail',
  'realname' => 'cn'
}
default['cicd_infrastructure']['nexus']['ldap']['groupdn'] = 'ou=groups'
default['cicd_infrastructure']['nexus']['ldap']['group_attrs'] = {
  'groupId' => 'cn',
  'objClass' => 'groupOfNames',
  'memberAttr' => 'member',
  'memberFormat' => 'uid=${username},ou=people,dc=example,dc=com'
}
# LDAP groups mapping
# Key - LDAP group
# Value - List of Nexus roles
default['cicd_infrastructure']['nexus']['ldap']['group_mapping'] = {
  'developers' => [
    'nx-admin'
  ]
}

default['cicd_infrastructure']['sonar']['auth'] = 'LDAP'
default['cicd_infrastructure']['sonar']['ldap']['realm'] = 'mydomain.com'
default['cicd_infrastructure']['sonar']['ldap']['security']['realm'] = 'LDAP'
default['cicd_infrastructure']['sonar']['ldap']['server'] = 'localhost'
default['cicd_infrastructure']['sonar']['ldap']['port'] = '389'
default['cicd_infrastructure']['sonar']['ldap']['basedn'] = 'dc=example,dc=com'
default['cicd_infrastructure']['sonar']['ldap']['rootdn'] = "cn=admin,\
#{node['cicd_infrastructure']['sonar']['ldap']['basedn']}"
default['cicd_infrastructure']['sonar']['ldap']['root_pwd'] = 'password'
default['cicd_infrastructure']['sonar']['ldap']['userdn'] = "ou=people,\
#{node['cicd_infrastructure']['sonar']['ldap']['basedn']}"
default['cicd_infrastructure']['sonar']['ldap']['groupdn'] = "ou=groups,\
#{node['cicd_infrastructure']['sonar']['ldap']['basedn']}"
