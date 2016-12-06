#!/bin/bash -e
set -o errexit
set -o nounset
set -o pipefail

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso)
  mkdir -p /mnt/virtualbox
  mount -o loop  ${HOME_DIR}/VBoxGuest*.iso /mnt/virtualbox
  sh /mnt/virtualbox/VBoxLinuxAdditions.run
  ln -s /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
  umount /mnt/virtualbox
  rm -rf ${HOME_DIR}/VBoxGuest*.iso
  ;;

vmware-iso)
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
  open-vm-tools
  ;;

*)
  echo "Unknown Packer Builder Type >>$PACKER_BUILDER_TYPE<< selected."
  echo "Known are virtualbox-iso|vmware-iso."
  echo "Aborting"
  exit 1
  ;;

esac
