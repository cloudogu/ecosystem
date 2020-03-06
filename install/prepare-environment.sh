#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# shellcheck disable=SC1091
source /etc/ces/functions.sh

# write current ip
# shellcheck disable=SC1091
source /etc/environment
export PATH

echo "writing ip to master node file"
get_ip > /etc/ces/node_master

# prepare syslog and restart
echo "prepare syslog and restart rsyslog service"
if [ ! -d /var/log/docker ]; then
  mkdir /var/log/docker
fi
chown syslog /var/log/docker
systemctl restart rsyslog.service

# Enable IP change check service
systemctl daemon-reload
systemctl enable ipchangecheck.service
