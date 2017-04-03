#!/bin/bash -e

{
    SERVICE="$1"
    if [ X"${SERVICE}" = X"" ]; then
        echo "usage create-sa.sh servicename"
        exit 1
    fi

    # create random schema suffix and password
    SCHEMA="${SERVICE}_$(doguctl random -l 6)"
    PASSWORD=$(doguctl random)

    # create database
    mysql -u root -e "CREATE DATABASE ${SCHEMA} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
    
    # grant access for user
    mysql -u root -e "grant all on ${SCHEMA}.* to \"${SCHEMA}\"@\"%\" identified by \"${PASSWORD}\";FLUSH PRIVILEGES;"
} >/dev/null 2>&1

# print details
echo "database: ${SCHEMA}"
echo "username: ${SCHEMA}"
echo "password: ${PASSWORD}"
