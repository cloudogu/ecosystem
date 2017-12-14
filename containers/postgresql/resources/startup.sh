#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

function mask2cidr() {
  NBITS=0
  IFS=.
  for DEC in $1 ; do
    case $DEC in
      255) let NBITS+=8;;
      254) let NBITS+=7 ; break ;;
      252) let NBITS+=6 ; break ;;
      248) let NBITS+=5 ; break ;;
      240) let NBITS+=4 ; break ;;
      224) let NBITS+=3 ; break ;;
      192) let NBITS+=2 ; break ;;
      128) let NBITS+=1 ; break ;;
      0);;
      *) echo "Error: ${DEC} is not recognised"; exit 1
    esac
  done
  echo "${NBITS}"
}

function create_hba() {
  echo '# generated, do not override'
  echo '# "local" is for Unix domain socket connections only'
  echo 'local   all             all                                     trust'
  echo '# IPv4 local connections:'
  echo 'host    all             all             127.0.0.1/32            trust'
  echo '# IPv6 local connections:'
  echo 'host    all             all             ::1/128                 trust'
  echo '# container networks'
  for NETWITHMASK in $(netstat -nr | tail -n +3 | grep -v '^0' | awk '{print $1"/"$3}'); do
    NET=$(echo "${NETWITHMASK}" | awk -F'/' '{print $1}')
    MASK=$(echo "${NETWITHMASK}" | awk -F'/' '{print $2}')
    CIDR=$(mask2cidr "$MASK")
    echo "host    all             all             ${NET}/${CIDR}  password"
  done
}

function initializePostgreSQL() {

    # set stage for health check
    doguctl state installing

    # install database
    gosu postgres initdb

    # postgres user
    POSTGRES_USER="postgres"

    # store the user
    doguctl config user "${POSTGRES_USER}"

    # create random password
    POSTGRES_PASSWORD=$(doguctl random)

    # store the password encrypted
    doguctl config -e password "${POSTGRES_PASSWORD}"

    # open port
    sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

    # set generated password
    echo "ALTER USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';" | 2>/dev/null 1>&2 gosu postgres postgres --single -jE

    # create /run/postgresql
    mkdir -p /run/postgresql
    chown postgres:postgres /run/postgresql

    # generate pg_hba.conf
    create_hba > "${PGDATA}"/pg_hba.conf
}

function waitForPostgreSQLStartup() {
  while ! pg_isready > /dev/null; do
    # Postgres is not ready yet to accept connections
    sleep 0.1
  done
}

function waitForPostgreSQLShutdown() {
  while pgrep -x postgres > /dev/null ; do
    # Postgres is still running
    sleep 0.1
  done
}

chown -R postgres "$PGDATA"
if [ -z "$(ls -A "$PGDATA")" ]; then
  initializePostgreSQL
elif [ -e "${PGDATA}"/postgresqlFullBackup.dump ]; then
  # Moving backup and emptying PGDATA directory
  mv "${PGDATA}"/postgresqlFullBackup.dump /tmp/postgresqlFullBackup.dump
  # New PostgreSQL version requires completely empty folder
  rm -rf "${PGDATA:?}"/*
  rm -rf "${PGDATA:?}"/.[^.] .??*

  initializePostgreSQL

  echo "Restoring database dump..."
  # Start postgres to restore backup
  gosu postgres postgres &
  PID=$!
  waitForPostgreSQLStartup
  # Restore backup
  psql -U postgres -f /tmp/postgresqlFullBackup.dump postgres
  rm /tmp/postgresqlFullBackup.dump
  # Kill postgres
  kill ${PID}
  waitForPostgreSQLShutdown
fi

# set stage for health check
doguctl state ready

# start database
exec gosu postgres postgres
