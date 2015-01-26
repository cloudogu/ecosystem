#!/bin/bash
apt-get update
apt-get install -yy $(cat $INSTALL_HOME/install/packages)
