#!/bin/bash

TARGET_FILE=/etc/systemd/system/docker-metadata.service.d/docker-metadata-environment

function get_enabled(){
  etcdctl get config/_global/proxy/enabled || echo "false"
}

if [ "$(get_enabled)" == "true" ]
then
  echo "collecting https proxy config steps..."
  HOST="$(etcdctl get config/_global/proxy/host)" || (echo "ERROR: Could not ready from etcd: proxy host" && exit 0)
  PORT="$(etcdctl get config/_global/proxy/port)" || (echo "ERROR: Could not ready from etcd: proxy host" && exit 0)
  USERNAME="$(etcdctl get config/_global/proxy/username)" || echo "WARNING: Could not ready from etcd: proxy host"
  PASSWORD="$(etcdctl get config/_global/proxy/password)" || echo "WARNING: Could not ready from etcd: proxy host"
  AUTH=""
  if [ "${USERNAME}" != "" ] && [ "${USERNAME}" != "" ]
  then
    AUTH="${USERNAME}:${PASSWORD}@"
  else
    echo "No username and password for proxy configured."
  fi

  HTTP_CONFIG="HTTP_PROXY=http://${HOST}:${PORT}"
  echo "http-proxy: ${HTTP_CONFIG/PASSWORD/******}"

  HTTPS_CONFIG="HTTPS_PROXY=https://${AUTH}${HOST}:${PORT}"
  echo "https-proxy: ${HTTPS_CONFIG/PASSWORD/******}"

  echo "${HTTPS_CONFIG}" > "${TARGET_FILE}"
  echo "${HTTP_CONFIG}" >> "${TARGET_FILE}"
fi


