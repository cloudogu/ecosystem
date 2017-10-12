#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

DOCKER_LOGROTATE="/var/log/docker/*.log {
    copytruncate
    size 100M
    rotate 2
    missingok
    compress
}"

# sync resources to fs
rsync -rav $INSTALL_HOME/resources/* /

# space for privilege adjustment
chmod u+x /etc/ces/*.sh
chmod o+x /usr/local/bin/ipchange.sh
chown root:root /etc/logrotate.d/docker

# define logrotate with "copytruncate" to prevent deleting log-files at logrotate
echo "$DOCKER_LOGROTATE" > /etc/logrotate.d/docker

# Reload systemd daemon to recognize dockeroptions config file
systemctl daemon-reload