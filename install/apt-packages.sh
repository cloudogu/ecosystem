#!/bin/bash
apt-get update
apt-get install -yy \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" $(cat $INSTALL_HOME/install/packages)
