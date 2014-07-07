# Encoding: utf-8
name             'cicd_infrastructure'
maintainer       'Grid Dynamics International, Inc.'
maintainer_email 'nyurin@griddynamics.com'
license          ''
description      'Installs/Configures CICD infrastructure'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'java'
depends 'jira'
depends 'nexus'
depends 'mysql'
depends 'jenkins'
