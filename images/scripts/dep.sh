#!/bin/bash
#
# Setup the the box. This runs as root
apt-get -y update
apt-get -y install htop iftop jq ruby ruby-dev

# Install docker
# see https://docs.docker.com/engine/installation/linux/ubuntulinux/

DOCKER_VERSION=1.12.3-0~trusty

echo "installing docker"
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list
apt-get -y update
apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
apt-get -y install docker-engine=$DOCKER_VERSION
echo "install docker - end"
