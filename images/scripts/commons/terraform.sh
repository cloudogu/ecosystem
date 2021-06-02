#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Install terraform
# See https://learn.hashicorp.com/tutorials/terraform/install-cli

TERRAFORM_VERSION=0.15.4

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
echo "deb [arch=amd64] https://apt.releases.hashicorp.com focal main" > /etc/apt/sources.list.d/hashicorp.list
# Install Terraform
apt-get -y update
apt-get -y install terraform=${TERRAFORM_VERSION}

echo "install terraform - end"
