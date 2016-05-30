#!/bin/bash
source /etc/ces/functions.sh

# update package index only for ces repository
apt-get update -o Dir::Etc::sourcelist="sources.list.d/ces.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
apt-get install -y --force-yes cesapp ces-setup

# service start automatically on docker restart
# docker restart is called after the overlay network configuration
# service ces-setup start
