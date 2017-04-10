#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Vagrant specific
date > /etc/vagrant_box_build_time

# Installing vagrant keys
mkdir -pm 700 /home/ces-admin/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/ces-admin/.ssh/authorized_keys
chmod 0600 /home/ces-admin/.ssh/authorized_keys
chown -R ces-admin /home/ces-admin/.ssh

# Customize the message of the day
echo 'Development Environment' > /etc/motd
