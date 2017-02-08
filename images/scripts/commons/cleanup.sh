#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Delete all Linux headers
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' \
  | xargs apt-get -y purge;

# Delete development packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev$' \
    | xargs apt-get -y purge;

# Delete X11 libraries
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6;

# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf;

# Delete oddities
apt-get -y purge popularity-contest;

apt-get -y autoremove;
apt-get -y clean;

echo "remove temporary install resources"
rm -f VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?;
rm -rf /home/ces-admin/resources /home/ces-admin/install/
