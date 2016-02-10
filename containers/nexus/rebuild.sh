#!/bin/bash
NAME="nexus";
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$(docker ps -a | awk '{print $NF}' | grep -v NAMES | grep $NAME)" = "$NAME" ]; then
	echo "$NAME container is going to be stopped now."
	docker stop $NAME
fi

echo "$NAME container is going to be recreated now."
docker rm $NAME
#docker rmi cesi/$NAME
$DIR/build.sh
$DIR/create.sh

echo "$NAME container is going to be started now."
docker start $NAME
