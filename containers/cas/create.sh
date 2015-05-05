#!/bin/bash

DATADIR="/var/lib/ces/cas"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

docker rm cas
docker create \
  --name cas \
  -h cas \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/cas \
  cesi/cas
