#!/bin/bash
mkdir -p /opt/ces/cesapp/bin
gunzip -c $INSTALL_HOME/packages/cesapp.gz > /opt/ces/cesapp/bin/cesapp
chmod +x /opt/ces/cesapp/bin/cesapp
ln -s /opt/ces/cesapp/bin/cesapp /opt/ces/bin/cesapp
