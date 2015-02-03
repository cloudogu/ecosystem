#!/bin/bash

export INSTALL_HOME=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

if [ $UID != 0 ]; then
  echo "please run as root"
  exit 1
fi

# create btrfs subvolumes
echo "creating btrfs subvolumes"
$INSTALL_HOME/install/create-subvolumes.sh

# snyc resources
echo "sync files"
$INSTALL_HOME/install/sync-files.sh

# install repository keys
echo "install repository keys"
$INSTALL_HOME/install/apt-keys.sh

# install packages
echo "install missing packages"
$INSTALL_HOME/install/apt-packages.sh

# install etcd
echo "install etcd"
$INSTALL_HOME/install/install-etcd.sh

# prepare environment
echo "prepare environment"
$INSTALL_HOME/install/prepare-environment.sh

# build containers
echo "install containers"
$INSTALL_HOME/dockerfile/install-containers.sh
