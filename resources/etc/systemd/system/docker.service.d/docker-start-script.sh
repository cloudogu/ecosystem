#!/bin/bash
function get_config_for(){
  PROTOCOL=$1
  USERNAME=$2
  PASSWORD=$3
  HOST=$4
  PORT=$5

  echo ""
}

echo "collecting https steps"
HTTPS_PROXY_USERNAME="$(etcdctl get config/nexus/proxyConfiguration/https/authentication/username)" || true
HTTPS_PROXY_PASSWORD="$(etcdctl get config/nexus/proxyConfiguration/https/authentication/password)" || true
HTTPS_PROXY_HOST="$(etcdctl get config/nexus/proxyConfiguration/https/host)" || true
HTTPS_PROXY_PORT="$(etcdctl get config/nexus/proxyConfiguration/https/port)" || true
#HTTPS_PROXY_CONFIG="https://${HTTPS_PROXY_USERNAME}:${HTTPS_PROXY_PASSWORD}@${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" || true
HTTPS_PROXY_CONFIG="$(get_config_for "https" "${HTTPS_PROXY_USERNAME}" "${HTTPS_PROXY_PASSWORD}" "${HTTPS_PROXY_HOST}" "${HTTPS_PROXY_PORT}")" || true


echo "collecting http steps"
HTTP_PROXY_USERNAME="$(etcdctl get config/nexus/proxyConfiguration/http/authentication/username)" || true
HTTP_PROXY_PASSWORD="$(etcdctl get config/nexus/proxyConfiguration/http/authentication/password)" || true
HTTP_PROXY_HOST="$(etcdctl get config/nexus/proxyConfiguration/http/host)" || true
HTTP_PROXY_PORT="$(etcdctl get config/nexus/proxyConfiguration/http/port)" || true
#HTTP_PROXY_CONFIG="http://${HTTP_PROXY_USERNAME}:${HTTP_PROXY_PASSWORD}@${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}"
HTTP_PROXY_CONFIG=$(get_config_for "http" "${HTTP_PROXY_USERNAME}" "${HTTP_PROXY_PASSWORD}" "${HTTP_PROXY_HOST}" "${HTTP_PROXY_PORT}") || true

#PROXY_EXCLUSIONS="$(etcdctl get config/nexus/proxyConfiguration/nonProxyHosts)"

echo "generating proxy settings"
PROXY_SETTINGS="${HTTP_PROXY_CONFIG} ${HTTPS_PROXY_CONFIG}"
PROXY_SETTINGS="--env HTTP_PROXY=\"\""

echo "actually starting dockerd"
echo "settings: '${PROXY_SETTINGS}'"
/usr/bin/dockerd -s btrfs --log-driver=syslog --cluster-store=etcd://127.0.0.1:4001 --cluster-advertise=127.0.0.1:4001 "${PROXY_SETTINGS}"
