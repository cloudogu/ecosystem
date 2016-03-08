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

  if [ -f "$DIR/dogu.json" ]; then

    /opt/ces/bin/cesapp install "$C"

    if [ "$2" = "start" ]; then
      echo "starting service for container $C"
      service "ces-$C" start
    fi

  elif [ -f "$DIR/Dockerfile" ]; then

    IMAGE=$(head -1 "$DIR/Dockerfile" | sed 's/#//g' | sed 's/\s*//g')
    docker pull "${IMAGE}"

  fi

done
