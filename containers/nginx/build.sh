#!/bin/bash
DOCKER_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)

docker build -t cesi/nginx-build -f ${DOCKER_DIR}/Dockerfile.build ${DOCKER_DIR}

mkdir ${DOCKER_DIR}/dist
docker run --rm -t -v ${DOCKER_DIR}/dist:/dist cesi/nginx-build

docker build -t cesi/nginx $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
