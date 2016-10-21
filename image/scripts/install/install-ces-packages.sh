#!/bin/bash
PACKAGES="cesapp ces-setup"
APTINSTALL=""

# import cloudogu key
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0249BCED

for PKG in $PACKAGES; do
  DEBPKG=$(ls /vagrant/${PKG}*.deb 2> /dev/null)
  if [ $? = 0 ]; then
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

# service start automatically on docker restart
# docker restart is called after the overlay network configuration
# service ces-setup start
