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
  apt-get update -o Dir::Etc::sourcelist="sources.list.d/ces.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
  apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages ${APTINSTALL}
fi

