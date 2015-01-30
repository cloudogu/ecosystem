#!/bin/bash
BASEDIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
CONTAINERS=$(cat $BASEDIR/containers)
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
done
