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

  if [ -d "$DIR/resources" ]; then
    echo "copy container required resources to host system"
    rsync -rav $DIR/resources/* /
  fi

  if [ "$2" = "start" ]; then
    echo "starting service for container $C"
    service "ces-$C" start
  fi
done
