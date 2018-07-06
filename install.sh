#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail


###
# altered the script to be able to execute the shell scripts, since exec-bit is missing, when mounted from mounted from windows file-system.
###

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

# install ces packages
echo "install ces packages"
/bin/bash -eux  $INSTALL_HOME/install/install-ces-packages.sh

# snyc resources
echo "sync files"
/bin/bash -eux $INSTALL_HOME/install/sync-files.sh

# source new path environment, to fix missing etcdctl
source /etc/environment
export PATH
echo "INSTALL_HOME=\"$INSTALL_HOME\"" >> /etc/environment

# create overlay network
# errormessages of test may be confusing to read ... perhaps this could be fixed later
echo "create network"
/bin/bash -eux $INSTALL_HOME/install/create-network.sh

# prepare environment
echo "prepare environment"
/bin/bash -eux $INSTALL_HOME/install/prepare-environment.sh

# building firewall
echo "building up a firewall"
/bin/bash -eux $INSTALL_HOME/install/firewall.sh

# restart docker
echo "restart docker with new config"
systemctl restart docker.service

# print setup message
/bin/bash -eux $INSTALL_HOME/install/setup-message.sh
