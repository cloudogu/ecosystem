#!/bin/bash -e

{
    SERVICE="$1"
    if [ X"${SERVICE}" = X"" ]; then
        echo "usage create-sa.sh servicename"
        exit 1
    fi

    # create random schema suffix and password
    ID=$(doguctl random -l 6 | tr '[:upper:]' '[:lower:]')
    USER="${SERVICE}_${ID}"
    PASSWORD=$(doguctl random)
    DATABASE="${USER}"
    SCHEMA="${USER}"

    # connection user
    ADMIN_USERNAME=$(doguctl config user)

    # create role
    psql -U ${ADMIN_USERNAME} -c "CREATE USER ${USER} WITH PASSWORD '${PASSWORD}';"

    # create database
    psql -U ${ADMIN_USERNAME} -c "CREATE DATABASE ${DATABASE} OWNER ${USER};"

} >/dev/null 2>&1

# print details
echo "database: ${DATABASE}"
echo "username: ${USER}"
echo "password: ${PASSWORD}"
