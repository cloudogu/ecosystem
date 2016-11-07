#!/bin/bash -e
echo "creating btrfs subvolumes"
btrfs subvolume create /var/lib/docker
btrfs subvolume create /var/lib/ces
echo "creating btrfs subvolumes - end"
