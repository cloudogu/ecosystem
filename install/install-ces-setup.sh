#!/bin/bash
source /etc/ces/functions.sh

CESSETUP_VERSION="0.0.2"

echo "install ces-setup v${CESSETUP_VERSION}"
URL="https://github.com/cloudogu/ces-setup/releases/download/v${CESSETUP_VERSION}/ces-setup_${CESSETUP_VERSION}.deb"
github_download "$URL" "/tmp/ces-setup_v${CESSETUP_VERSION}.deb"
dpkg -i "/tmp/ces-setup_v${CESSETUP_VERSION}.deb"
rm -f "/tmp/ces-setup_v${CESSETUP_VERSION}.deb"

# start service manually for the first time
service ces-setup start
