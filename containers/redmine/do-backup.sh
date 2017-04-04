#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Prepare !!!!!!!!

# - Add 'COPY do-backup.sh /do-backup.sh' to Dockerfile
# - Add the following lines to dogu.json:
#  "ExposedCommands": [{
#    "Name": "do-backup",
#    "Description": "Creates a backup of redmine",
#    "Command": "/do-backup.sh"
#  }],


USER=$(doguctl config -e sa-postgresql/username)
PASSWORD=$(doguctl config -e sa-postgresql/password)

PGPASSWORD=${PASSWORD} pg_dump -h postgresql -U ${USER} -d ${USER}
