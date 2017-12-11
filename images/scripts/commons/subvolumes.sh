#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

echo "creating btrfs subvolumes"
btrfs subvolume create /var/lib/docker
btrfs subvolume create /var/lib/ces
echo "creating btrfs subvolumes - end"
