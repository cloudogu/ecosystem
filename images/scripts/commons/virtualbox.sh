#!/bin/bash -e
mkdir -p /mnt/virtualbox
mount -o loop  ${HOME_DIR}/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
ln -s /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
umount /mnt/virtualbox
rm -rf ${HOME_DIR}/VBoxGuest*.iso
