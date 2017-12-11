#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

FQDN=$(doguctl config --global fqdn)
ADMUSR="$1"
ADMPW="$2"
ADMINGROUP="$3"

if ! doguctl wait --port 8081 --timeout 120; then 
  echo "Nexus seems not to be started. Exiting."
  exit 1
fi

# set ADMINGROUP as nx-admins
echo "Set group $ADMINGROUP as nx-admins"
ADMIN_GROUP_RESPONSE=$(curl -s --retry 3 --retry-delay 10 -H "Content-Type: application/json" -X POST -d "{data:{id:\"$ADMINGROUP\",name:\"$ADMINGROUP\",description:\"$ADMINGROUP\",sessionTimeout:60,roles:[nx-admin],privileges:[]}}" "http://localhost:8081/nexus/service/local/roles" -u "$ADMUSR":"$ADMPW")
# {"errors":[{"id":"id","msg":"Role ID must be unique."}]} means admin group is already set
echo "Response from set admin group: ${ADMIN_GROUP_RESPONSE}"
# update base url
SETTINGS=$(curl -s -H 'content-type:application/json' -H 'accept:application/json' 'http://127.0.0.1:8081/nexus/service/local/global_settings/current' -u "$ADMUSR":"$ADMPW" | jq ".data.globalRestApiSettings+={\"baseUrl\": \"https://$FQDN/nexus/\"}")
curl -s -H "Content-Type: application/json" -X PUT -d "$SETTINGS" "http://127.0.0.1:8081/nexus/service/local/global_settings/current" -u "$ADMUSR":"$ADMPW"
