#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Install terraform
# See https://learn.hashicorp.com/tutorials/terraform/install-cli

TERRAFORM_VERSION=0.14.6

export DEBIAN_FRONTEND=noninteractive

echo "installing terraform"
# Add Hashicorps’s official GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
# Verify key
KEY=$(sudo apt-key fingerprint A3219F7B)
if [ -z "${KEY}" ]; then
  echo "Hashicorp key has not been added successfully";
  exit 1
fi
# Add repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com bionic main"
# Install Terraform
apt-get -y update
apt-get -y install terraform=${TERRAFORM_VERSION}

echo "install terraform - end"