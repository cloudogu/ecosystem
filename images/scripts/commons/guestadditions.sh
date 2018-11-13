#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso)
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
  gcc make perl
  mkdir -p /mnt/virtualbox
  mount -o loop  ${HOME_DIR}/VBoxGuest*.iso /mnt/virtualbox
  # encapsulate execution because of false positve (https://github.com/dotless-de/vagrant-vbguest/issues/168)
  if sh /mnt/virtualbox/VBoxLinuxAdditions.run
  then
  echo "VBoxLinuxAdditions.run was successful"
  fi
  # link to guest additions is already present
  #ln -s /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
  umount /mnt/virtualbox
  rm -rf ${HOME_DIR}/VBoxGuest*.iso
  ;;

vmware-iso)
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
  open-vm-tools
  ;;

qemu)
  ;;

*)
  echo "Unknown Packer Builder Type >>$PACKER_BUILDER_TYPE<< selected."
  echo "Known are virtualbox-iso|vmware-iso."
  echo "Aborting"
  exit 1
  ;;

esac
