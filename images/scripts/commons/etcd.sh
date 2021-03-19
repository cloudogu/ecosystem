#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# This script relies on Cloudogu apt repository beeing present. See ces_apt.sh

echo "installing etcd - start"

# install etcd
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages ces-etcd

# Starting etcd is not necessary, because it is done in the postinst script of the etcd package
# See https://github.com/cloudogu/etcd/blob/develop/deb/DEBIAN/postinst#L16

echo "installing etcd - end"
