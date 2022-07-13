#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# be sure we are root
if [ "$(id -u)" -ne 0 ]; then
  echo "please run as root"
  exit 1
fi

# set install home, if not set
if [ -z ${INSTALL_HOME+x} ]; then
  INSTALL_HOME=$(cd "$( dirname "${0}" )" && pwd)
fi
export INSTALL_HOME

# Make sure all scripts are executable
# This may not be the case when Packer build is started from Windows machines
chmod +x "$INSTALL_HOME"/install/*.sh

# install ces packages
echo "install ces packages"
"$INSTALL_HOME"/install/install-ces-packages.sh

# sync resources
echo "sync files"
"$INSTALL_HOME"/install/sync-files.sh

# source new path environment, to fix missing etcdctl
# file is in resources/etc/environment
# shellcheck disable=SC1091
source /etc/environment
export PATH
echo "INSTALL_HOME=\"$INSTALL_HOME\"" >> /etc/environment

# create overlay network
# errormessages of test may be confusing to read ... perhaps this could be fixed later
echo "create network"
"$INSTALL_HOME"/install/create-network.sh

# prepare environment
echo "prepare environment"
"$INSTALL_HOME"/install/prepare-environment.sh

# building firewall
echo "building up a firewall"
"$INSTALL_HOME"/install/firewall.sh

# restart docker
echo "restart docker with new config"
systemctl restart docker.service

# install cesappd. This must be done separately and cannot be done in the `install-ces-packages.sh`-Script.
# See #450 for more information.
echo "Installing cesappd"
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages cesappd

# print setup message
"$INSTALL_HOME"/install/setup-message.sh
