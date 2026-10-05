#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Install terraform
# See https://learn.hashicorp.com/tutorials/terraform/install-cli
# See https://www.hashicorp.com/official-packaging-guide

TERRAFORM_VERSION=1.9.1-1

export DEBIAN_FRONTEND=noninteractive

echo "installing terraform"
# Download the signing key to a new keyring
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
# Verify the key's fingerprint
if ! (gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint | grep "D55C 0D1A C78A 8D81 26CB  631C FC9C A96A CA02 6560" > /dev/null); then
  echo "Could not verify hashicorp key fingerprint"
  exit 1
fi
# Add repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
# Install Terraform
apt-get -y update
apt-get -y install terraform=${TERRAFORM_VERSION}

echo "install terraform - end"
