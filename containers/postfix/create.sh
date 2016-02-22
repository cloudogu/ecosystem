#!/bin/sh

docker create \
	--name postfix \
	-h mail \
	-v /etc/ces:/etc/ces \
	--log-driver="syslog" \
	--log-opt='syslog-tag=postfix' \
	cesi/postfix
