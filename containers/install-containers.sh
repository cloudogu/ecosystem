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

  if [ -f "$DIR/docker/dogu.json" ]; then

    /opt/ces/bin/cesapp build "$DIR/docker"

    if [ "$2" = "start" ]; then
      echo "starting service for container $C"
      service "ces-$C" start
    fi

  elif [ -f "$DIR/docker/Dockerfile" ]; then

    IMAGE=$(head -1 "$DIR/docker/Dockerfile" | sed 's/#//g' | sed 's/\s*//g')
    docker build -t "${IMAGE}" "$DIR/docker"

  fi

done
