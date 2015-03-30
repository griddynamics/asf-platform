# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Attributes:: default
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

default['cicd_infrastructure']['jenkins'].tap do |jenkins|
  jenkins['plugins'] = {
    'mailer' => '',
    'openid4java' => '',
    'openid' => '',
    'promoted-builds' => '',
    'credentials' => '',
    'ssh-credentials' => '',
    'ssh-agent' => '',
    'scm-api' => '',
    'parameterized-trigger' => '',
    'token-macro' => '',
    'config-file-provider' => '2.7.5',
    'gerrit-trigger' => '',
    'matrix-auth' => '',
    'cloudbees-folder' => '',
    'job-dsl' => '',
    'rebuild' => '',
    'copyartifact' => '1.30',
    'envinject' => '',
    'groovy' => '',
    'jira' => '1.39',
    'htmlpublisher' => '',
    'analysis-core' => '',
    'email-ext' => '2.38.2',
    'sonar' => '',
    'pmd' => '',
    'findbugs' => '',
    'checkstyle' => '',
    'dry' => '',
    'port-allocator' => '',
    'ec2' => '1.24',
    'git' => '',
    'git-client' => ''
  }
  jenkins['pubkey'] = nil
  jenkins['gerrit-trigger']['host'] = 'localhost'
  jenkins['gerrit-trigger']['ssh_port'] = '29418'
  jenkins['gerrit-trigger']['http_port'] = '80'

  jenkins['auth'] = 'LDAP'
  jenkins['ldap']['server'] = nil
  jenkins['ldap']['port'] = '389'
  jenkins['ldap']['basedn'] = 'dc=asf,dc=griddynamics,dc=com'
  jenkins['ldap']['userdn'] = 'ou=people'
  jenkins['ldap']['user_id'] = 'uid={0}'
  jenkins['ldap']['rootdn'] = 'cn=admin,dc=asf,dc=griddynamics,dc=com'
  jenkins['ldap']['root_pwd'] = 'password'

  jenkins['mail']['address'] = 'jenkins@asf.griddynamics.com'
  jenkins['mail']['smtp']['host'] = 'localhost'

  jenkins['qubell-plugin']['username'] = nil
  jenkins['qubell-plugin']['password'] = nil
  jenkins['qubell-plugin']['application_id'] = '12345'
  jenkins['qubell-plugin']['environment_id'] = '54321'
  jenkins['qubell-plugin']['endpoint'] = 'https://express.qubell.com/'
  jenkins['qubell-plugin']['version'] = '2.5'
  jenkins['qubell-plugin']['checksum'] = '7dc571813114ce521bc22580c8b0e0b3'
  jenkins['qubell-plugin']['url'] = 'https://github.com/qubell/' \
    'contrib-jenkins-qubell-plugin/releases/download/' \
    "v#{jenkins['qubell-plugin']['version']}/" \
    "jenkins-qubell-plugin-#{jenkins['qubell-plugin']['version']}.hpi"

  jenkins['nexus']['endpoint'] = nil
  jenkins['nexus']['username'] = 'deployment'
  jenkins['nexus']['password'] = 'deployment123'
  jenkins['selenium']['endpoint'] = nil
  jenkins['selenium']['version'] = '2.44.0'

  jenkins['jira']['host'] = nil
  jenkins['jira']['username'] = nil
  jenkins['jira']['password'] = nil
  jenkins['jira']['plugin']['version'] = '1.4.6.1'
  jenkins['jira']['plugin']['url'] = 'http://repository.marvelution.org/' \
    'service/local/repositories/releases/content/com/marvelution/jira/' \
    "plugins/jenkins-jira-plugin/#{jenkins['jira']['plugin']['version']}/" \
    "jenkins-jira-plugin-#{jenkins['jira']['plugin']['version']}.hpi"

  jenkins['plugin']['jbehave']['version'] = '3.7'
  jenkins['plugin']['jbehave']['url'] = 'https://nexus.codehaus.org/content/' \
  'repositories/releases/org/jbehave/jbehave-jenkins-plugin/' \
  "#{jenkins['plugin']['jbehave']['version']}/jbehave-jenkins-plugin-" \
  "#{jenkins['plugin']['jbehave']['version']}.hpi"

  jenkins['plugin']['xunit']['version'] = '1.89'
  jenkins['plugin']['xunit']['url'] = 'http://updates.jenkins-ci.org/' \
    "download/plugins/xunit/#{jenkins['plugin']['xunit']['version']}/xunit.hpi"

  jenkins['sonar']['host'] = nil
  jenkins['sonar']['private_ip'] = nil
  jenkins['sonar']['port'] = '9000'
  jenkins['sonar']['username'] = nil
  jenkins['sonar']['password'] = nil

  jenkins['ec2']['region'] = nil
  jenkins['ec2']['accessId'] = nil
  jenkins['ec2']['secretKey'] = nil
  jenkins['ec2']['instanceCap'] = nil
  jenkins['ec2']['keyPairName'] = nil
  jenkins['ec2']['slaveCredentials'] = 'fa3aab48-4edc-446d-b1e2-1d89d86f4458'
  jenkins['ec2']['mavenVersion'] = '3.1.1'
  jenkins['ec2']['antVersion'] = '1.9.4'
  jenkins['ec2']['groovyVersion'] = '2.2.1'
  jenkins['ec2']['jdkVersion'] = '7u71'
  jenkins['ec2']['mavenInstallationUrl']  = "https://s3.amazonaws.com/gd-asf/apache-maven-#{jenkins['ec2']['mavenVersion']}-bin.tar.gz"
  jenkins['ec2']['antInstallationUrl']    = "https://s3.amazonaws.com/gd-asf/apache-ant-#{jenkins['ec2']['antVersion']}-bin.tar.gz"
  jenkins['ec2']['groovyInstallationUrl'] = "https://s3.amazonaws.com/gd-asf/groovy-binary-#{jenkins['ec2']['groovyVersion']}.zip"
  jenkins['ec2']['jdkInstallationUrl']    = "https://s3.amazonaws.com/gd-asf/jdk-#{jenkins['ec2']['jdkVersion']}-linux-x64.tar.gz"
  jenkins['ec2']['template'] = {
    ami: nil,
    description: 'slave',
    zone: nil,
    securityGroups: nil,
    remoteFS: '/mnt/.jenkins',
    labels: 'build',
    type: nil,
    mode: 'NORMAL',
    jvmopts: '',
    subnetId: '',
    userData: '',
    numExecutors: '4',
    remoteAdmin: 'ubuntu',
    stopOnTerminate: 'false',
    idleTerminationMinutes: '45',
    useEphemeralDevices: 'true',
    customDeviceMapping: 'false',
    stopOnTerminate: 'false',
    launchTimeout: '1800'
  }
  jenkins['docker']['registry'] = nil
  jenkins['docker']['shipyard'] = nil
end

default['cicd_infrastructure']['gerrit'].tap do |gerrit|
  gerrit['jenkins_host'] = nil
  gerrit['jenkins_pubkey'] = nil
  gerrit['auth']['type'] = 'LDAP'
  gerrit['ldap']['server'] = 'localhost'
  gerrit['ldap']['accountBase'] = 'ou=people,dc=asf,dc=griddynamics,dc=com'
  gerrit['ldap']['accountPattern'] = '(&(objectClass=inetOrgPerson)' \
    '(uid=${username}))'
  gerrit['ldap']['groupBase'] = 'ou=groups,dc=asf,dc=griddynamics,dc=com'
  gerrit['ldap']['groupMemberPattern'] = '(|(member=${dn})(uniqueMember=${dn}))'
  gerrit['ldap']['accountFullName'] = 'displayName'
  gerrit['ldap']['accountEmailAddress'] = 'mail'
  gerrit['sendemail']['enable'] = 'true'
  gerrit['sendemail']['smtpServer'] = 'localhost'
  gerrit['sendemail']['smtpServerPort'] = '25'
end

default['cicd_infrastructure']['nexus'].tap do |nexus|
  nexus['auth'] = 'LDAP'
  nexus['ldap']['server'] = 'localhost'
  nexus['ldap']['port'] = '389'
  nexus['ldap']['basedn'] = 'dc=asf,dc=griddynamics,dc=com'
  nexus['ldap']['rootdn'] = "cn=admin,#{nexus['ldap']['basedn']}"
  nexus['ldap']['root_pwd'] = 'password'
  nexus['ldap']['scheme'] = 'simple'
  nexus['ldap']['userdn'] = 'ou=people'
  nexus['ldap']['user_attrs'] = {
    'userId' => 'uid',
    'userPwd' => 'userPassword',
    'objClass' => 'inetOrgPerson',
    'mail' => 'mail',
    'realname' => 'cn'
  }
  nexus['ldap']['groupdn'] = 'ou=groups'
  nexus['ldap']['group_attrs'] = {
    'groupId' => 'cn',
    'objClass' => 'groupOfNames',
    'memberAttr' => 'member',
    'memberFormat' => 'uid=${username},ou=people,dc=asf,dc=griddynamics,dc=com'
  }
  # LDAP groups mapping
  # Key - LDAP group
  # Value - List of Nexus roles
  nexus['ldap']['group_mapping'] = {
    'developers' => [
      'nx-admin'
    ]
  }
  nexus['login'] = 'admin'
  nexus['password'] = 'admin123'

  nexus['repo']['build']['main']['id'] = 'builds-main'
  nexus['repo']['build']['main']['name'] = 'Builds - mainline'
  nexus['repo']['build']['main']['policy'] = 'SNAPSHOT'
  nexus['repo']['build']['main']['ttl'] = '14'
  nexus['repo']['build']['main']['snapshots'] = '0'
  nexus['repo']['build']['feature']['id'] = 'builds-feature'
  nexus['repo']['build']['feature']['name'] = 'Builds - feature branches'
  nexus['repo']['build']['feature']['policy'] = 'SNAPSHOT'
  nexus['repo']['build']['feature']['ttl'] = '14'
  nexus['repo']['build']['feature']['snapshots'] = '0'
  nexus['repo']['build']['group']['id'] = 'builds-all'
  nexus['repo']['build']['group']['name'] = 'Builds - all'
  nexus['repo']['build']['promote']['group']['id'] = 'builds-promoted'
  nexus['repo']['build']['promote']['group']['name'] = 'Builds - promoted'

  nexus['repo']['promote']['id'] = 'builds-main-promoted'
  nexus['repo']['promote']['name'] = 'Builds-main-promoted'
  nexus['repo']['promote']['policy'] = 'SNAPSHOT'
  nexus['repo']['promote']['ttl'] = '99'
  nexus['repo']['promote']['snapshots'] = '0'

  nexus['repo']['gd']['id'] = 'cd-releases'
  nexus['repo']['gd']['name'] = 'GD CD Releases'
  nexus['repo']['gd']['policy'] = 'Release'
  nexus['repo']['gd']['location'] = 'https://nexus.griddynamics.net/' \
    'nexus/content/repositories/cd-releases/'
end

default['cicd_infrastructure']['sonar'].tap do |sonar|
  sonar['credentials']['username'] = nil
  sonar['credentials']['password'] = nil

  sonar['auth'] = 'LDAP'
  sonar['ldap']['realm'] = 'mydomain.com'
  sonar['ldap']['security']['realm'] = 'LDAP'
  sonar['ldap']['server'] = 'localhost'
  sonar['ldap']['port'] = '389'
  sonar['ldap']['basedn'] = 'dc=asf,dc=griddynamics,dc=com'
  sonar['ldap']['rootdn'] = "cn=admin,\
    #{sonar['ldap']['basedn']}"
  sonar['ldap']['root_pwd'] = 'password'
  sonar['ldap']['userdn'] = "ou=people,\
    #{sonar['ldap']['basedn']}"
  sonar['ldap']['groupdn'] = "ou=groups,\
    #{sonar['ldap']['basedn']}"

  sonar['mail']['from'] = 'sonar@asf.griddynamics.com'
  sonar['mail']['smtp_host.secured'] = 'localhost'
  sonar['mail']['smtp_port.secured'] = '25'
end

default['cicd_infrastructure']['jira'].tap do |jira|
  jira['ldap']['server'] = 'localhost'
  jira['ldap']['port'] = '389'
  jira['ldap']['basedn'] = 'dc=asf,dc=griddynamics,dc=com'
  jira['ldap']['rootdn'] = "cn=admin,#{jira['ldap']['basedn']}"
  jira['ldap']['root_pwd'] = 'password'
  jira['ldap']['scheme'] = 'simple'
  jira['ldap']['userdn'] = 'ou=people'
  jira['ldap']['user_attrs'] = {
    'userId' => 'uid',
    'userPwd' => 'userPassword',
    'objClass' => 'inetorgperson',
    'mail' => 'mail',
    'realname' => 'givenName'
  }
  jira['ldap']['groupdn'] = 'ou=groups'
  jira['ldap']['group_attrs'] = {
    'groupId' => 'cn',
    'objClass' => 'groupOfUniqueNames',
    'memberAttr' => 'uniqueMember',
    'memberFormat' => 'uid=${username},ou=people,dc=asf,dc=griddynamics,dc=com'
  }
  jira['plugins'] = {
    #   'jira-jenkins-plugin' => {
    #     'type' => 'obr',
    #     'url' => 'https://marketplace.atlassian.com/download/plugins/com.marvelution.jira.plugins.jenkins/version/212'
    #   },
    #   'rest-api-browser' => {
    #     'type' => 'jar',
    #     'url' => 'https://marketplace.atlassian.com/download/plugins/com.atlassian.labs.rest-api-browser/version/3110'
    #   }
  }
end
