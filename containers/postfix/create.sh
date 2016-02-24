#!/bin/sh

docker create \
	--name postfix \
	-h mail \
	-v /etc/ces:/etc/ces \
	--log-driver="syslog" \
	--log-opt='syslog-tag=postfix' \
	--net=cesnet1 \
	cesi/postfix
