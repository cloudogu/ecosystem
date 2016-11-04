#!/bin/bash

# check if etcd was started with docker

if /opt/ces/bin/etcdctl cluster-health; then
  # restarting docker and upstart should start etcd as well
  >&2 echo "WARNING: etcd seem not to be started, restarting docker"
  service docker restart
fi

echo "creating overlay network"
docker network create --driver overlay cesnet1
