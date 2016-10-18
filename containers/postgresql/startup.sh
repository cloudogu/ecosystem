#!/bin/bash
chown -R postgres "$PGDATA"
if [ -z "$(ls -A "$PGDATA")" ]; then

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
  echo "ALTER USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';" | gosu postgres postgres --single -jE
fi

# set stage for health check
doguctl state ready

# start database
exec gosu postgres postgres