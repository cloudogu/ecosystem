#!/bin/bash

# Copy resources to the right place
cp -r /home/cesadmin/resources/etc/* /etc/
cp -r /home/cesadmin/resources/usr/* /usr/
chmod ug+x /home/cesadmin/install/*
chmod ug+x /etc/ces/functions.sh

# # source new path environment, to fix missing etcdctl
# echo "PATH ="
# echo $PATH
# #EN=$(cat /etc/environment) # source /etc/environment
# export $(cat /etc/environment) #PATH
# echo "PATH ="
# echo $PATH
# echo "INSTALL_HOME=\"$INSTALL_HOME\"" >> /etc/environment
# echo "/etc/environment ="
# EN=$(cat /etc/environment)
# echo $EN

# # Remove packages installed in dep.sh
# apt-get remove htop iftop jq ruby ruby-dev

# # Remove packages installed in base.sh
# apt-get remove build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev unzip

# # Remove subvolume created in subvolumes.sh
# btrfs subvolume delete /opt/ces
