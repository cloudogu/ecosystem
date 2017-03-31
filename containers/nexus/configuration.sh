#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source /etc/ces/functions.sh

FQDN=$(get_fqdn)
ADMUSR="$1"
ADMPW="$2"
ADMINGROUP="$3"

if ! doguctl wait --port 8081 --timeout 120; then 
  echo "Nexus seems not to be started. Exiting."
  exit 1
fi

# set ADMINGROUP as nx-admins
echo "set group $ADMINGROUP as nx-admins"
if curl --retry 3 --retry-delay 10 -s -H "Content-Type: application/json" -X POST -d "{data:{id:\"$ADMINGROUP\",name:\"$ADMINGROUP\",description:\"$ADMINGROUP\",sessionTimeout:60,roles:[nx-admin],privileges:[]}}" "http://localhost:8081/nexus/service/local/roles" -u "$ADMUSR":"$ADMPW"; then
  echo "Already set admin group"
fi
# update base url
SETTINGS=$(curl -H 'content-type:application/json' -H 'accept:application/json' 'http://127.0.0.1:8081/nexus/service/local/global_settings/current' -u "$ADMUSR":"$ADMPW" | jq ".data.globalRestApiSettings+={\"baseUrl\": \"https://$FQDN/nexus/\"}")
curl -H "Content-Type: application/json" -X PUT -d "$SETTINGS" "http://127.0.0.1:8081/nexus/service/local/global_settings/current" -u "$ADMUSR":"$ADMPW"
