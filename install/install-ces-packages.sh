#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

PACKAGES="cesapp ces-setup"
APTINSTALL=""

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
  apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages ${APTINSTALL}
fi

## Make systemd acknowledge ces-setup
#echo "Reloading systemd daemon"
#systemctl daemon-reload
## enabling ces-setup to make it start even after reboot
#echo "Enabling ces-setup"
#systemctl enable ces-setup.service
#echo "Restarting ces-setup"
#systemctl restart ces-setup.service
