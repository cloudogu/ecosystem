#!/bin/bash

function createSubVolume(){
  SV_PATH="$1"
  if [ ! -d "$SV_PATH" ]; then
    btrfs subvolume create "$SV_PATH"
  else
    echo "$SV_PATH already exists"
  fi
}

for SV in $(cat $INSTALL_HOME/install/subvolumes); do
  createSubVolume "$SV"
done
