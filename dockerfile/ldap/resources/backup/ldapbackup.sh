#!/bin/bash

BACKUP_PATH=/backup

nice slapcat -n 0 > ${BACKUP_PATH}/config.ldif
nice slapcat -n 1 > ${BACKUP_PATH}/meinedomain.local.ldif
nice slapcat -n 2 > ${BACKUP_PATH}/access.ldif
chmod 640 ${BACKUP_PATH}/*.ldif
