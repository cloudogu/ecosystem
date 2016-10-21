#!/bin/bash
echo "creating btrfs subvolumes"
sudo btrfs subvolume create /var/lib/docker
sudo btrfs subvolume create /var/lib/ces
#sudo btrfs subvolume create /opt/ces
echo "creating btrfs subvolumes - end"
