#!/bin/bash

# check if etcd was started with docker
/opt/ces/bin/etcdctl cluster-health
if [ ! $? -eq 0 ]; then
  # restarting docker and upstart should start etcd as well
  >&2 echo "ERROR: etcd seem not to be started, restarting docker"
  service docker restart
fi
docker network create --driver overlay cesnet1
