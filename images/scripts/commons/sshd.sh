#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config
