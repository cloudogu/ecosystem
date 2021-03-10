#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

echo "installing etcd - start"

if [ ! -d /etc/apt/sources.list.d ]; then
  mkdir -p /etc/apt/sources.list.d
fi

echo "deb [arch=amd64] https://apt.cloudogu.com/ces/ bionic main" > /etc/apt/sources.list.d/ces.list

# import cloudogu key
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0249BCED

# update package index only for ces repository
apt-get update -o Dir::Etc::sourcelist="sources.list.d/ces.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

# install etcd
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages ces-etcd

# Starting etcd is not necessary, because it is done in the postinst script of the etcd package
# See https://github.com/cloudogu/etcd/blob/develop/deb/DEBIAN/postinst#L16

echo "installing etcd - end"
