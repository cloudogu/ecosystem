#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Vagrant specific
date > /etc/vagrant_box_build_time

# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Configure vagrant user for password-less sudo
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Customize the message of the day
echo 'Development Environment' > /etc/motd
