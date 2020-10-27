#!/bin/bash

HTTPS_PROXY_USERNAME="$(etcdctl get config/nexus/proxyConfiguration/https/authentication/username)"
HTTPS_PROXY_PASSWORD="$(etcdctl get config/nexus/proxyConfiguration/https/authentication/password)"
HTTPS_PROXY_HOST="$(etcdctl get config/nexus/proxyConfiguration/https/host)"
HTTPS_PROXY_PORT="$(etcdctl get config/nexus/proxyConfiguration/https/port)"
HTTPS_PROXY_CONFIG="https://${HTTPS_PROXY_USERNAME}:${HTTPS_PROXY_PASSWORD}@${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}"

HTTP_PROXY_USERNAME="$(etcdctl get config/nexus/proxyConfiguration/http/authentication/username)"
HTTP_PROXY_PASSWORD="$(etcdctl get config/nexus/proxyConfiguration/http/authentication/password)"
HTTP_PROXY_HOST="$(etcdctl get config/nexus/proxyConfiguration/http/host)"
HTTP_PROXY_PORT="$(etcdctl get config/nexus/proxyConfiguration/http/port)"
HTTP_PROXY_CONFIG="http://${HTTP_PROXY_USERNAME}:${HTTP_PROXY_PASSWORD}@${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}"

PROXY_EXCLUSIONS="$(etcdctl get config/nexus/proxyConfiguration/nonProxyHosts)"

PROXY_SETTINGS="--env HTTP_PROXY=\"${HTTP_PROXY_CONFIG}\" --env HTTPS_PROXY=\"${HTTPS_PROXY_CONFIG}\" --env NO_PROXY=\"${PROXY_EXCLUSIONS}\""

echo "${PROXY_SETTINGS}" > /myfile

/usr/bin/dockerd -s btrfs --log-driver=syslog --cluster-store=etcd://127.0.0.1:4001 --cluster-advertise=127.0.0.1:4001 "${PROXY_SETTINGS}"
