#!/bin/bash
NAME=$1;
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$(docker ps -a | awk '{print $NF}' | grep -v NAMES | grep $NAME)" = "$NAME" ]; then
	echo "$NAME container is going to be stopped now."
	docker stop $NAME
fi

echo "$NAME container is going to be recreated now."
docker rm -f $NAME
docker rmi cesi/$NAME
$DIR/$NAME/build.sh
$DIR/$NAME/create.sh

echo "$NAME container is going to be started now."
docker start $NAME

