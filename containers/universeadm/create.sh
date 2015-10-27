#!/bin/bash

DATADIR="/var/lib/ces/universeadm"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

docker rm universeadm
docker create \
  --name universeadm \
  -h universeadm \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/universeadm \
  --log-driver="syslog" \
  --log-opt='syslog-tag=universeadm' \
  cesi/universeadm
