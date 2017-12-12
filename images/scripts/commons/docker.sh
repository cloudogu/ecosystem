#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Install docker
# See https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

DOCKER_VERSION=17.09.1~ce-0~ubuntu

export DEBIAN_FRONTEND=noninteractive

echo "installing docker"
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Verify key
KEY=$(sudo apt-key fingerprint 0EBFCD88)
if [ -z "${KEY}" ]; then
  echo "Docker key has not been added successfully";
  exit 1
fi
# Add stable repository
sudo add-apt-repository "deb [arch=amd64] \
https://download.docker.com/linux/ubuntu xenial stable"
# Install Docker
apt-get -y update
apt-get -y install docker-ce=${DOCKER_VERSION}

echo "install docker - end"
