# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "cloudoguEcoSystem"
  config.vm.box_url = "http://192.168.115.138/vagrant/cloudoguEcoSystem/0.1.0/cloudoguEcoSystem.box"
  config.vm.box_download_checksum_type = "sha256"
  config.vm.box_download_checksum = "575adf4241dc8020061d72dc9b98dec6ae20c939c16d5e732c1a0307f4b0b7bb"

  # use bridged netword
  # to get the ip use vagrant ssh -c ifconfig
  #
  config.vm.network "public_network"

  # create flag file to set appliance type to vagrant
  config.vm.provision "shell",
    inline: "mkdir /etc/ces && echo 'vagrant' > /etc/ces/type && /vagrant/install.sh"

end
