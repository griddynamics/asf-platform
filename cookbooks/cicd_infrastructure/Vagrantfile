# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.omnibus.chef_version = 'latest'
  config.berkshelf.enabled = true

  config.vm.provider "virtualbox" do |v, override|
    override.vm.box = 'centos-6.5'
    override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{config.vm.box}_chef-provisionerless.box"
    config.vm.hostname = 'cicd-infrastructure'
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
    }

    chef.run_list = [
        'recipe[cicd-infrastructure::default]'
    ]
  end
end
