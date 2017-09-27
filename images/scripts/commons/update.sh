#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Disable release-upgrades
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

# disable periodic updates
cat <<EOF > /etc/apt/apt.conf.d/99_disable_periodic_update
APT::Periodic::Enable "0";
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOF

# stop and kill apt-daily
systemctl stop apt-daily.timer
systemctl disable apt-daily.timer
systemctl stop apt-daily.service
systemctl daemon-reload
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    sleep 1;
done


# dist upgrade
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y upgrade

reboot
sleep 60
