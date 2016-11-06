#!/bin/bash

SWAPUUID=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
if [ "x${SWAPUUID}" != "x" ]; then
  # Whiteout the swap partition to reduce box size
  # Swap is disabled till reboot
  SWAPPART=$(readlink -f "/dev/disk/by-uuid/${SWAPUUID}")
  /sbin/swapoff "${SWAPPART}"
  dd if=/dev/zero of="${SWAPPART}" bs=1M || echo "dd exit code $? is suppressed"
  /sbin/mkswap -U "${SWAPUUID}" "${SWAPPART}"
fi

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# Sync to ensure that the delete completes before this moves on.
sync
sync
sync
