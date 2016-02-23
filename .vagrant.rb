# -*- mode: ruby -*-
# vi: set ft=ruby :

config.vm.networks.each do |n|
	n[1][:bridge] = "eth0"
end

config.vm.provider "virtualbox" do |v|
	v.memory = 5000
	v.cpus = 2
	v.linked_clone = true
end
