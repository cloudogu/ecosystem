#!/bin/bash

export INSTALL_HOME=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

if [ $UID != 0 ]; then
  echo "please run as root"
  exit 1
fi

# snyc resources
echo "sync files"
$INSTALL_HOME/install/sync-files.sh

# source new path environment, to fix missing etcdctl
source /etc/environment
export PATH

# create overlay network
# errormessages of test may be confusing to read ... perhaps this could be fixed later
echo "create network"
$INSTALL_HOME/install/create-network.sh

# prepare environment
echo "prepare environment"
$INSTALL_HOME/install/prepare-environment.sh

# install cesapp
echo "install cesapp"
$INSTALL_HOME/install/install-cesapp.sh

# install cesapp
echo "install ces-setup"
$INSTALL_HOME/install/install-ces-setup.sh

# restart docker
echo "restart docker with new config"
service docker restart
