#!/bin/bash -e

if ! service etcd status | grep 'running' &> /dev/null; then
  >&2 echo "service etcd is not running, starting ..."
  service etcd start &>/dev/null
  sleep 1
fi

for i in $(seq 1 5); do
  if ! /opt/ces/bin/etcdctl cluster-health &> /dev/null; then
    sleep 1
    if /opt/ces/bin/etcdctl cluster-health &> /dev/null; then
      break
    else
      >&2 echo "etcd is not running, try to restart (retry counter $i)..."
      service etcd restart &>/dev/null
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
  service docker restart
fi

echo "creating overlay network ..."
docker network create --driver overlay cesnet1
