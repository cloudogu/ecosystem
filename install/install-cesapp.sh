#!/bin/bash
source /etc/ces/functions.sh

CESAPP_VERSION="0.3.1"

echo "install cesapp v${CESAPP_VERSION}"
mkdir -p /opt/ces/cesapp/bin
URL="https://github.com/cloudogu/cesapp/releases/download/v${CESAPP_VERSION}/cesapp-v${CESAPP_VERSION}.tar.gz"
github_download "$URL" | gunzip | tar -x cesapp/bin/cesapp -O > /opt/ces/cesapp/bin/cesapp
chmod +x /opt/ces/cesapp/bin/cesapp
ln -s /opt/ces/cesapp/bin/cesapp /opt/ces/bin/cesapp
