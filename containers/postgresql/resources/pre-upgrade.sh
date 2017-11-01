#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
echo "DEBUG: PRE-UPGRADE"
pg_dumpall -U postgres -f /var/lib/postgresql/postgresqlFullBackup.dump
#rm -rf /var/lib/postgresql/*
echo "DEBUG: PRE-UPGRADE DONE"
