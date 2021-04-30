#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Install fail2ban
FAIL2BAN_VERSION=0.10.2-2

export DEBIAN_FRONTEND=noninteractive

echo "installing fail2ban"

# Install fail2ban
apt-get -y update
apt-get -y install fail2ban=${FAIL2BAN_VERSION}

echo "install fail2ban - end"

# Configure fail2ban for sshd
echo "configuring fail2ban for sshd"

# Values are taken from default configuration
fail2ban-client set sshd maxretry 5
fail2ban-client set sshd findtime 10m
fail2ban-client set sshd bantime 10m
fail2ban-client set sshd addlogpath /var/log/auth.log

echo "configuring fail2ban for sshd - end"
