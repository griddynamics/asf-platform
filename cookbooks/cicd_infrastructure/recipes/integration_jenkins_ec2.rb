# Encoding: utf-8
#
# Cookbook Name:: cicd-infrastructure
# Recipe:: integration_jenkins_ec2
#
# Copyright (c) 2014 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

node.set['cicd_infrastructure']['jenkins']['ec2']['template'][:initScript] =
"sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c \"echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list\"
sudo apt-get update
sudo apt-get install --yes lxc-docker-1.4.1 unzip
sudo mkdir -p /mnt/.jenkins
sudo chown ubuntu:ubuntu /mnt/.jenkins
sudo sh -c \"echo DOCKER_OPTS=\\'--registry-mirror=#{node['cicd_infrastructure']['jenkins']['docker']['registry']} --tlsverify=false --insecure-registry=#{File.basename(node['cicd_infrastructure']['jenkins']['docker']['registry'])}\\' > /etc/default/docker\"
sudo service docker restart
sudo iptables -F INPUT
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
sudo iptables -A INPUT -s 172.16.0.0/12 -j ACCEPT
sudo iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
sudo iptables -A INPUT -j DROP
"

jenkins_ec2_config = node['cicd_infrastructure']['jenkins']['ec2']
jenkins_ssh_dir = "#{node['jenkins']['master']['home']}/.ssh"
accessId = jenkins_ec2_config['accessId']
secretKey = jenkins_ec2_config['secretKey']
keyPairName = jenkins_ec2_config['keyPairName'] || 'jenkins-slave'

service 'jenkins' do
  action :nothing
end

bash 'Import keypair to EC2' do
  code <<-EOH
    source /etc/profile
    ec2-delete-keypair #{keyPairName}
    ec2-import-keypair #{keyPairName} --public-key-file #{jenkins_ssh_dir}/id_rsa.pub
    EOH
  environment(
      'AWS_ACCESS_KEY' => accessId,
      'AWS_SECRET_KEY' => secretKey
  )
  notifies :execute, 'jenkins_script[Encrypt private key for ec2]', :immediately
end

jenkins_script 'Encrypt private key for ec2' do
  command <<-EOH.gsub(/^ {4}/, '')
    import hudson.util.Secret
    def strKey = new File('#{jenkins_ssh_dir}/id_rsa').text
    Secret key;
    key = Secret.fromString(strKey);
    File keyFile = new File('/tmp/private_key.enc')
    keyFileWriter = keyFile.newWriter()
    keyFileWriter << key.getEncryptedValue()
    keyFileWriter.close()
    EOH
  action :nothing
  notifies :execute, 'jenkins_script[Encrypt Amazon secret key]', :immediately
end

jenkins_script 'Encrypt Amazon secret key' do
  command <<-EOH.gsub(/^ {4}/, '')
    import hudson.util.Secret
    def strKey = '#{ secretKey }'
    Secret password;
    password = Secret.fromString(strKey);
    File keyFile = new File('/tmp/secret_key.enc')
    keyFileWriter = keyFile.newWriter()
    keyFileWriter << password.getEncryptedValue()
    keyFileWriter.close()
    EOH
  action :nothing
  notifies :configure, 'cicd_infrastructure_jenkins_ec2_cloud[Configure jenkins ec2]', :immediately
end

cicd_infrastructure_jenkins_ec2_cloud 'Configure jenkins ec2' do
  accessId accessId
  secretKey lazy {
    load_enc_key_cmd = Mixlib::ShellOut.new('cat', '/tmp/secret_key.enc')
    load_enc_key_cmd.run_command
    load_enc_key_cmd.stdout
  }
  privateKey lazy {
    load_enc_key_cmd = Mixlib::ShellOut.new('cat', '/tmp/private_key.enc')
    load_enc_key_cmd.run_command
    load_enc_key_cmd.stdout
  }
  instanceCap jenkins_ec2_config['instanceCap']
  region jenkins_ec2_config['region']
  templates [jenkins_ec2_config['template']]
  action :nothing
  notifies :restart, 'service[jenkins]', :immediately
end

template "#{node['jenkins']['master']['home']}/hudson.plugins.git.GitTool.xml" do
  source 'integration/jenkins/hudson.plugins.git.GitTool.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  notifies :restart, 'service[jenkins]'
end
