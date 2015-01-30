#!/bin/bash

DATADIR="/var/lib/ces/nexus"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

docker rm nexus
docker create \
  --name nexus \
  -h nexus \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/nexus \
  cesi/nexus
