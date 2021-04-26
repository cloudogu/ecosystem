#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

echo "Adding Cloudogu apt repository..."

if [ ! -d /etc/apt/sources.list.d ]; then
  mkdir -p /etc/apt/sources.list.d
fi

# Note: This should comply to the settings in https://github.com/cloudogu/ces-commons/blob/develop/deb/DEBIAN/postinst
echo "deb [arch=amd64] https://apt.cloudogu.com/ces/ focal main" > /etc/apt/sources.list.d/ces.list

# import cloudogu key
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0249BCED

# update package index only for ces repository
apt-get update -o Dir::Etc::sourcelist="sources.list.d/ces.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
