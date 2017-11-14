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
  if ! etcdctl cluster-health &> /dev/null; then
    sleep 1
    if etcdctl cluster-health &> /dev/null; then
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

if ! etcdctl cluster-health &> /dev/null; then
  >&2 echo "failed to start etcd ..."
  exit 1
fi

if ! docker info | grep -i 'cluster store' | grep 'etcd' &> /dev/null; then
  echo "docker is not configured for etcd, restarting docker ..."
  systemctl restart docker.service
fi


# use bridge network, because there seems to be an issue in the overlay driver
echo "creating network cesnet1 ..."
docker network create cesnet1

# create docker_gwbridge network since it is not created automatically by the ecosystem at this step but it is needed for firewall settings
# echo "creating docker_gwbridge network"
# docker network create docker_gwbridge -d bridge --gateway 172.18.0.1 --subnet 172.18.0.0/16 --opt com.docker.network.bridge.enable_icc=false --opt com.docker.network.bridge.enable_ip_masquerade=true --opt com.docker.network.bridge.name=docker_gwbridge
