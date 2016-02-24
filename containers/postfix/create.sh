#!/bin/sh

docker create \
	--name postfix \
	-h mail \
	-v /etc/ces:/etc/ces \
	--log-driver="syslog" \
	--log-opt='syslog-tag=postfix' \
	registry.cloudogu.com/official/postfix:3.0.4-1
