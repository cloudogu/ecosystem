# -*- mode: ruby -*-
# vi: set ft=ruby :

# use at least vagrant 1.9.0 in combination with Ubuntu 16.04
Vagrant.require_version ">= 1.9.0"

Vagrant.configure(2) do |config|

  # https://atlas.hashicorp.com/cloudogu/boxes/ecosystem-basebox
  config.vm.box = "cloudogu/ecosystem-basebox"
  config.vm.hostname = "ces"
  config.vm.box_version = "0.6.0"

  # use bridged netword
  # to get the ip use vagrant ssh -c ifconfig
  config.vm.network "public_network"

  # private network configuration
  # config.vm.network "private_network", ip: "192.168.42.2"

  # create flag file to set appliance type to vagrant
  config.vm.provision "shell",
    inline: "mkdir /etc/ces && echo 'vagrant' > /etc/ces/type && /vagrant/install.sh"

  # configure virtual hardware
  config.vm.provider "virtualbox" do |v|
    v.memory = 3072
    # v.cpus = 2

    # enable dns host resolver
    # v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # load custom configurations
  if File.file?(".vagrant.rb")
    eval File.read(".vagrant.rb")
  end

end
