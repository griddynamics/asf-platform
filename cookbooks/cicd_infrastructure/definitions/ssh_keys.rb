# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Definition:: ssh_keys
#
# Copyright 2014, Grid Dynamics International, Inc.
#

define :ssh_keys, name: nil,
                  user: 'root',
                  group: 'root',
                  filename: nil,
                  action: :create do
  if params[:action] == :create
    fail AttributeError, 'definition name isn\'t set' if params[:name].nil?

    dir = params[:name]
    user = params[:user]
    group = params[:group]
    filename = params[:filename]
    filename ||= 'id_rsa'

    chef_gem 'sshkey'

    # Base location of ssh key
    pkey = "#{dir}/#{filename}"

    # Generate a keypair with Ruby
    require 'sshkey'
    sshkey = SSHKey.generate(
      type: 'RSA',
      comment: "#{user}@#{node['fqdn']}"
    )

    # Store private key on disk
    file pkey do
      content sshkey.private_key
      owner user
      group group
      mode 00600
      action :create_if_missing
    end

    # Store public key on disk
    file "#{pkey}.pub" do
      content sshkey.ssh_public_key
      owner user
      group group
      mode 00600
      action :create_if_missing
    end
  end
end
