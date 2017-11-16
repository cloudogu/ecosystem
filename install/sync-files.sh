#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# sync resources to fs
rsync -rav --chown=root:root $INSTALL_HOME/resources/* /

# space for privilege adjustment
chmod u+x /etc/ces/*.sh
chmod o+x /usr/local/bin/ipchange.sh
chown root:root /etc/logrotate.d/docker

# Reload systemd daemon to recognize dockeroptions config file
systemctl daemon-reload
