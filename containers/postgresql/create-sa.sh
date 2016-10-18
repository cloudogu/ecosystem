#!/bin/bash -e
SERVICE="$1"
if [ "${SERVICE}" == "" ]; then
  echo "usage create-sa.sh servicename"
  exit 1
fi

# create random schema suffix and password
SCHEMA="${SERVICE}_$(doguctl random -l 6)"
PASSWORD=$(doguctl random)

# connection user
ADMIN_USERNAME=$(doguctl config user)

# create database
2>/dev/null 1>&2 psql -U ${ADMIN_USERNAME} -c "CREATE USER ${SCHEMA} WITH PASSWORD '${PASSWORD}';"

# grant access for user
2>/dev/null 1>&2 psql -U ${ADMIN_USERNAME} -c "CREATE DATABASE ${SCHEMA} OWNER ${SCHEMA};"

# print details
echo "database: ${SCHEMA}"
echo "username: ${SCHEMA}"
echo "password: ${PASSWORD}"
