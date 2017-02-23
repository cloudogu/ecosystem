#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# TODO: check this if statement on correctness
if ! systemctl is-active etcd.service | grep 'active' &> /dev/null; then
  >&2 echo "service etcd is not running, starting ..."
  systemctl start etcd.service &>/dev/null
  sleep 1
fi

for i in $(seq 1 5); do
  if ! /opt/ces/bin/etcdctl cluster-health &> /dev/null; then
    sleep 1
    if /opt/ces/bin/etcdctl cluster-health &> /dev/null; then
      break
    else
      >&2 echo "etcd is not running, try to restart (retry counter $i)..."
      systemctl restart etcd.service &>/dev/null
    fi
  else
    echo "etcd successfully started ..."
    break
  fi
done

if ! /opt/ces/bin/etcdctl cluster-health &> /dev/null; then
  >&2 echo "failed to start etcd ..."
  exit 1
fi

if ! docker info | grep -i 'cluster store' | grep 'etcd' &> /dev/null; then
  echo "docker is not configured for etcd, restarting docker ..."
  systemctl restart docker.service
fi

echo "creating overlay network ..."
docker network create --driver overlay cesnet1
