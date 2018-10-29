#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso)
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
  virtualbox-guest-dkms
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
