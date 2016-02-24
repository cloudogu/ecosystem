#!/bin/bash
DOCKER_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
docker build -t registry.cloudogu.com/official/nginx-build:1.9.11-1 -f ${DOCKER_DIR}/Dockerfile.build ${DOCKER_DIR}

mkdir ${DOCKER_DIR}/dist
docker run --rm -t -v ${DOCKER_DIR}/dist:/dist registry.cloudogu.com/official/nginx-build:1.9.11-1

docker build -t registry.cloudogu.com/official/nginx:1.9.11-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
