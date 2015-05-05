#!/bin/bash

#you can add a soecific volume to handle configuration data like so

DATADIR="/var/lib/ces/YOURAPPLICATION"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

#step 1: remove an existing container
docker rm YOURCONTAINERNAME
#step 2: create your container
docker create \
  --name YOURCONTAINERNAME \
  -h cas \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/YOURAPPLICATION \
  YOURCONTAINERNAME
