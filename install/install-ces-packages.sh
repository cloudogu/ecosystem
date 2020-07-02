#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

PACKAGES="cesapp ces-setup ces-goss ces-commons restic backup-watcher"
APTINSTALL=""

for PKG in $PACKAGES; do
  if ls /vagrant/"${PKG}"*.deb 2> /dev/null; then
    DEBPKG=$(ls /vagrant/"${PKG}"*.deb 2> /dev/null)
    echo "installing ${PKG} from development package ${DEBPKG}..."
    dpkg -i "${DEBPKG}"
  else
    echo "Added ${PKG} to list to install from apt repository"
    APTINSTALL="${APTINSTALL} ${PKG}"
  fi
done

if [ "${APTINSTALL}" != "" ]; then
  echo "Updating ces package list..."
  apt-get update -o Dir::Etc::sourcelist="sources.list.d/ces.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
  echo "Installing ces packages ${APTINSTALL}..."
  # Word splitting is okay at this point as there may be multiple package names in ${APTINSTALL}
  # shellcheck disable=SC2086
  apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages ${APTINSTALL}
fi

