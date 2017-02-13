#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

PACKAGES="cesapp ces-setup"
APTINSTALL=""

# import cloudogu key
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0249BCED

for PKG in $PACKAGES; do
  if ls /vagrant/${PKG}*.deb 2> /dev/null; then
    DEBPKG=$(ls /vagrant/${PKG}*.deb 2> /dev/null)
    echo "install ${PKG} from development package ${DEBPKG}"
    dpkg -i ${DEBPKG}
  else
    echo "install ${PKG} from apt repository"
    APTINSTALL="${APTINSTALL} ${PKG}"
  fi
done

if [ "${APTINSTALL}" != "" ]; then
  # update package index only for ces repository
  apt-get update -o Dir::Etc::sourcelist="sources.list.d/ces.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
  apt-get install -y --force-yes cesapp ces-setup
fi

# TESTING
cat << 'EOF' >> /lib/systemd/system/ces-setup.service
[Unit]
Description=CES setup
Wants=docker.service
After=network.target docker.service

[Service]
ExecStart=/usr/sbin/ces-setup
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target

EOF

echo "Removing /etc/init/ces-setup.conf"
rm /etc/init/ces-setup.conf
echo "Reloading systemd daemon"
systemctl daemon-reload
# enabling ces-setup to make it start even after reboot
echo "enabling ces-setup"
systemctl enable ces-setup.service
echo "restarting ces-setup"
systemctl restart ces-setup.service

# END OF TESTING

# service start automatically on docker restart
# docker restart is called after the overlay network configuration
# service ces-setup start
