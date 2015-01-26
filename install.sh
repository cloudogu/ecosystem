#!/bin/bash

export INSTALL_HOME=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

if [ $UID != 0 ]; then
  echo "please run as root"
  exit 1
fi

# create structure

# create btrfs subvolumes
$INSTALL_HOME/install/create-subvolumes.sh

# snyc resources
$INSTALL_HOME/install/sync-files.sh

# install repository keys
$INSTALL_HOME/install/apt-keys.sh

# install packages
$INSTALL_HOME/install/apt-packages.sh
