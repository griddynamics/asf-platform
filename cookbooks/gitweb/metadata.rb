name              'gitweb'
maintainer        'Nikolay Yurin'
maintainer_email  'nyurin@griddynamics.com'
license           'Apache 2.0'
description       'Gitweb installation and configuration'
version           '0.1.0'

%w{ git apache2 }.each do |cb|
    depends cb
end

%w{ rhel centos fedora }.each do |sp|
    supports sp
end
