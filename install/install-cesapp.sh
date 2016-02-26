#!/bin/bash
source /etc/ces/functions.sh

echo "install cesapp"
mkdir -p /opt/ces/cesapp/bin
URL="https://github.com/cloudogu/cesapp/releases/download/v0.3.0/cesapp-v0.3.0.tar.gz"
github_download "$URL" | gunzip | tar -x cesapp/bin/cesapp -O > /opt/ces/cesapp/bin/cesapp
chmod +x /opt/ces/cesapp/bin/cesapp
ln -s /opt/ces/cesapp/bin/cesapp /opt/ces/bin/cesapp
