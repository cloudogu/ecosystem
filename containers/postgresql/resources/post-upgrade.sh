#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

if [ -e /var/lib/postgresql/UPGRADE.FLAG ]; then
  echo "DEBUG: UPGRADE.FLAG IS SET"
  # Remove all files but the backup
  # echo "DEBUG: REMOVING ALL FILES EXCEPT THE BACKUP"
  # find /var/lib/postgresql/ ! -name 'postgresqlFullBackup.dump' -type f -exec rm -f {} +
  # find /var/lib/postgresql/* ! -name 'postgresqlFullBackup.dump' -type d -exec rm -rf {} +
  #
  # echo "DEBUG: INITDB"
  # gosu postgres initdb
  # ls -la /var/lib/postgresql/
  # echo "DEBUG: RESTORING DATABASE DUMP"
  # gosu postgres postgres
  # PID=$$
  # echo "Started postgres with pid ${PID}"
  # psql -U postgres -f /var/lib/postgresql/postgresqlFullBackup.dump postgres
else
  echo "DEBUG: UPGRADE.FLAG IS NOT SET"
fi
