#!/bin/bash
BASEDIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
CONTAINERFILE="$BASEDIR/$1"

if [ ! -f "$CONTAINERFILE" ]; then
  echo "could not find container file"
  exit 1
fi

CONTAINERS=$(cat $CONTAINERFILE)
for C in $CONTAINERS; do
  DIR="$BASEDIR/$C"
  if [ ! -f "$DIR/build.sh" ]; then
    echo "could not find build script for container $C"
    exit 1
  fi
  echo "execute build script for container $C"
  $DIR/build.sh
  if [ -f "$DIR/create.sh" ]; then
    echo "create container $C"
    $DIR/create.sh
  fi
  echo "copy container required resources to host system"
  if [ -d "$DIR/resources" ]; then
    rsync -rav $DIR/resources/* /
  fi
done
