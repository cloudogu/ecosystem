#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Install fail2ban
FAIL2BAN_VERSION=0.11.1-1

export DEBIAN_FRONTEND=noninteractive

echo "installing fail2ban"

# Install fail2ban
apt-get -y update
apt-get -y install fail2ban=${FAIL2BAN_VERSION}

# Configure fail2ban for sshd
echo "configuring fail2ban for sshd"

# Values are taken from default configuration
fail2ban-client set sshd addignoreip 127.0.0.1/8
fail2ban-client set sshd maxretry 5
fail2ban-client set sshd findtime 10m
fail2ban-client set sshd bantime 10m
fail2ban-client set sshd addlogpath /var/log/auth.log
