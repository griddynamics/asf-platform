# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Attributes:: default
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

default['cicd_infrastructure']['jenkins']['plugins'] = {
  'mailer'=>'',
  'openid4java'=>'',
  'openid'=>'',
  'promoted-builds'=>'',
  'credentials'=>'',
  'ssh-credentials'=>'',
  'ssh-agent'=>'',
  'git-client'=>'',
  'scm-api'=>'',
  'git'=>'',
  'parameterized-trigger'=>'',
  'gerrit-trigger'=>'',
  'token-macro'=>'',
  'config-file-provider'=>'2.7.5',
  'gerrit-trigger'=>'',
  'matrix-auth'=>'',
  'cloudbees-folder'=>'',
  'job-dsl'=>'', 
  'rebuild'=>''}
default['cicd_infrastructure']['jenkins']['pubkey'] = nil
default['cicd_infrastructure']['jenkins']['gerrit-trigger']['host'] = 'localhost'
default['cicd_infrastructure']['jenkins']['gerrit-trigger']['ssh_port'] = '29418'
default['cicd_infrastructure']['jenkins']['gerrit-trigger']['http_port'] = '80'

default['cicd_infrastructure']['jenkins']['auth'] = 'LDAP'
default['cicd_infrastructure']['jenkins']['ldap']['server'] = nil
default['cicd_infrastructure']['jenkins']['ldap']['port'] = '389'
default['cicd_infrastructure']['jenkins']['ldap']['basedn'] = 'dc=example,dc=com'
default['cicd_infrastructure']['jenkins']['ldap']['userdn'] = 'ou=people'
default['cicd_infrastructure']['jenkins']['ldap']['user_id'] = 'uid={0}'
default['cicd_infrastructure']['jenkins']['ldap']['rootdn'] = 'cn=admin,dc=example,dc=com'
default['cicd_infrastructure']['jenkins']['ldap']['root_pwd'] = 'password'

default['cicd_infrastructure']['jenkins']['qubell-plugin']['username'] = nil
default['cicd_infrastructure']['jenkins']['qubell-plugin']['password'] = nil
default['cicd_infrastructure']['jenkins']['qubell-plugin']['application_id'] = '12345'
default['cicd_infrastructure']['jenkins']['qubell-plugin']['environment_id'] = '54321'
default['cicd_infrastructure']['jenkins']['qubell-plugin']['endpoint'] = 'https://express.qubell.com/'
default['cicd_infrastructure']['jenkins']['qubell-plugin']['version'] = '2.5'
default['cicd_infrastructure']['jenkins']['qubell-plugin']['checksum'] = '7dc571813114ce521bc22580c8b0e0b3'
default['cicd_infrastructure']['jenkins']['qubell-plugin']['url'] =
  "https://github.com/qubell/contrib-jenkins-qubell-plugin/releases/download/\
v#{node['cicd_infrastructure']['jenkins']['qubell-plugin']['version']}/\
jenkins-qubell-plugin-#{node['cicd_infrastructure']['jenkins']['qubell-plugin']['version']}.hpi"

default['cicd_infrastructure']['jenkins']['nexus']['endpoint'] = nil

default['cicd_infrastructure']['gerrit']['jenkins_host'] = nil
default['cicd_infrastructure']['gerrit']['jenkins_pubkey'] = nil
default['cicd_infrastructure']['gerrit']['auth']['type'] = 'LDAP'
default['cicd_infrastructure']['gerrit']['ldap']['server'] = 'ldap://localhost'
default['cicd_infrastructure']['gerrit']['ldap']['accountBase'] = 'ou=people,dc=example,dc=com'
default['cicd_infrastructure']['gerrit']['ldap']['accountPattern'] = '(&(objectClass=inetOrgPerson)(uid=${username}))'
default['cicd_infrastructure']['gerrit']['ldap']['accountFullName'] = 'displayName'
default['cicd_infrastructure']['gerrit']['ldap']['accountEmailAddress'] = 'mail'

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
default['cicd_infrastructure']['nexus']['login'] = 'admin'
default['cicd_infrastructure']['nexus']['password'] = 'admin123'
default['cicd_infrastructure']['nexus']['repo']['build']['id'] = 'builds'
default['cicd_infrastructure']['nexus']['repo']['build']['name'] = 'Builds'
default['cicd_infrastructure']['nexus']['repo']['build']['policy'] = 'SNAPSHOT'
default['cicd_infrastructure']['nexus']['repo']['build']['ttl'] = '20160'
default['cicd_infrastructure']['nexus']['repo']['promote']['id'] = 'builds-promoted'
default['cicd_infrastructure']['nexus']['repo']['promote']['name'] = 'Builds-promoted'
default['cicd_infrastructure']['nexus']['repo']['promote']['policy'] = 'SNAPSHOT'
default['cicd_infrastructure']['nexus']['repo']['promote']['ttl'] = '129600'

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

default['cicd_infrastructure']['jira']['ldap']['host'] = 'localhost'
default['cicd_infrastructure']['jira']['ldap']['port'] = '389'
default['cicd_infrastructure']['jira']['ldap']['basedn'] = 'dc=example,dc=com'
default['cicd_infrastructure']['jira']['ldap']['rootdn'] = "cn=admin,#{node['cicd_infrastructure']['jira']['ldap']['basedn']}"
default['cicd_infrastructure']['jira']['ldap']['root_pwd'] = 'password'
default['cicd_infrastructure']['jira']['ldap']['scheme'] = 'simple'
default['cicd_infrastructure']['jira']['ldap']['userdn'] = 'ou=people'
default['cicd_infrastructure']['jira']['ldap']['user_attrs'] = {
  'userId' => 'uid',
  'userPwd' => 'userPassword',
  'objClass' => 'inetorgperson',
  'mail' => 'mail',
  'realname' => 'givenName'
}
default['cicd_infrastructure']['jira']['ldap']['groupdn'] = 'ou=groups'
default['cicd_infrastructure']['jira']['ldap']['group_attrs'] = {
  'groupId' => 'cn',
  'objClass' => 'groupOfUniqueNames',
  'memberAttr' => 'uniqueMember',
  'memberFormat' => 'uid=${username},ou=people,dc=example,dc=com'
}
