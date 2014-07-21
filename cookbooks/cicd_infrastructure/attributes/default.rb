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
