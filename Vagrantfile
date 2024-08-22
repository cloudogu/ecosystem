# -*- mode: ruby -*-
# vi: set ft=ruby :

# use at least vagrant 1.9.0 in combination with Ubuntu 16.04
Vagrant.require_version ">= 1.9.0"

Vagrant.configure(2) do |config|

  config.vm.box = "cloudogu/ecosystem-basebox-v24.04.0-1"
  config.vm.box_url = "https://storage.googleapis.com/cloudogu-ecosystem/basebox/virtualbox/v24.04.0-1/basebox-virtualbox-v24.04.0-1.box"
  config.vm.box_download_checksum = "448e86eb14aef60d9defea7f7c32807c9437f1bc41153bbb8a6e9210484bf577"
  config.vm.box_download_checksum_type = "sha256"

  config.vm.hostname = "ces"

  # use bridged network
  # to get the ip use vagrant ssh -c ifconfig
  # config.vm.network "public_network"

  # private network configuration
  # 192.168.56.x is the network provided by the default host-only adapter for VirtualBox in Windows.
  # Using it does not require administrative privileges. It also works on Linux.
  config.vm.network "private_network", ip: "192.168.56.10"

  # force permissions on windows
  if Vagrant::Util::Platform.windows? then
    config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=755,fmode=755"]
  end

  # create flag file to set appliance type to vagrant
  config.vm.provision "shell",
    inline: "mkdir -p /etc/ces && echo 'vagrant' > /etc/ces/type && /vagrant/install.sh"

  # configure virtual hardware
  config.vm.provider "virtualbox" do |v|
    v.name = "ecosystem-" + Time.now.to_f.to_s
    v.memory = 8192
    v.cpus = 4

    # enable dns host resolver
    # v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # load custom configurations. Allows for changes (e.g. for development) without changing Vagrantfile, i.e. the Git repo.
  # See https://github.com/cloudogu/ecosystem/wiki/Tips-and-Tricks
  if File.file?(".vagrant.rb")
    eval File.read(".vagrant.rb")
  end

end
