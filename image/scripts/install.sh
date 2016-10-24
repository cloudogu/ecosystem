#!/bin/bash

export INSTALL_HOME=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

if [ $UID != 0 ]; then
  echo "please run as root"
  exit 1
fi

# Copy resources to the right place
cp -r /home/cesadmin/resources/etc/* /etc/
cp -r /home/cesadmin/resources/usr/* /usr/
chmod ug+x /home/cesadmin/install/*
chmod ug+x /etc/ces/functions.sh

# sync resources
echo "sync files"
$INSTALL_HOME/install/sync-files.sh

# source new path environment, to fix missing etcdctl
echo "PATH ="
echo $PATH
#EN=$(cat /etc/environment) # source /etc/environment
export $(cat /etc/environment) #PATH
echo "PATH ="
echo $PATH
echo "INSTALL_HOME=\"$INSTALL_HOME\"" >> /etc/environment
echo "/etc/environment ="
EN=$(cat /etc/environment)
echo $EN

# create overlay network
# errormessages of test may be confusing to read ... perhaps this could be fixed later
echo "create network"
$INSTALL_HOME/install/create-network.sh

# prepare environment
echo "prepare environment"
$INSTALL_HOME/install/prepare-environment.sh

# install ces packages
echo "install ces packages"
$INSTALL_HOME/install/install-ces-packages.sh

# restart docker
echo "restart docker with new config"
service docker restart

# print setup message
$INSTALL_HOME/install/setup-message.sh
