#!/bin/bash
source /etc/ces/functions.sh
FQDN=$(get_fqdn)
ADMUSR="$1"
ADMPW="$2"
ADMINGROUP="$3"
tries=0
while ! [ $(curl -sL -w "%{http_code}" "http://localhost:8081/nexus" -u $ADMUSR:$ADMPW -o /dev/null) -eq 200 ]
do
  ((tries++))
  echo "wait for nexus (configuration)"
  sleep 1
  if [ $tries -gt 200 ]
    then
      echo "nexus didnt start"
      echo "exit now"
      exit 1
  fi
done
# set ADMINGROUP as nx-admins
echo "set group $ADMINGROUP as nx-admins"
curl -s -H "Content-Type: application/json" -X POST -d "{"data":{"id":"$ADMINGROUP","name":"$ADMINGROUP","description":"$ADMINGROUP","sessionTimeout":60,"roles":["nx-admin"],"privileges":[]}}" "http://localhost:8081/nexus/service/local/roles" -u $ADMUSR:$ADMPW
# update base url
settings=$(curl -H 'content-type:application/json' -H 'accept:application/json' 'http://127.0.0.1:8081/nexus/service/local/global_settings/current' -u "$ADMUSR":"$ADMPW" | jq ".data.globalRestApiSettings+={\"baseUrl\": \"https://$FQDN/nexus/\"}")
curl -H "Content-Type: application/json" -X PUT -d "$settings" "http://127.0.0.1:8081/nexus/service/local/global_settings/current" -u "$ADMUSR":"$ADMPW"
