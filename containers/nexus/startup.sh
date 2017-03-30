#!/bin/bash
source /etc/ces/functions.sh

# variables
ADMUSR="admin"
ADMDEFAULTPW="admin123"
ADMINGROUP=$(doguctl config --global admin_group)
DOMAIN=$(doguctl config --global domain)
FQDN=$(doguctl config --global fqdn)

# create truststore
TRUSTSTORE="/var/lib/nexus/truststore.jks"
create_truststore.sh "${TRUSTSTORE}" > /dev/null

START_NEXUS="java \
  -server -Djava.net.preferIPv4Stack=true -Xms256m -Xmx1g \
  -Djavax.net.ssl.trustStore=${TRUSTSTORE} \
	-Djavax.net.ssl.trustStorePassword=changeit \
  -Dnexus-work=/var/lib/nexus -Dnexus-webapp-context-path=/nexus \
  -cp conf/:`(echo lib/*.jar) | sed -e "s/ /:/g"` \
  org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml"

if [ "$(doguctl config -e "admin_password")" ] 
  then
  echo "Set new admin password"
  ADMPW=$(doguctl random)
  $START_NEXUS &
  if ! doguctl wait --port 8081 --timeout 120; then 
    echo "Nexus seems not to be started. Exiting."
    exit 1
  fi
  curl --retry 3 --retry-delay 10 -X POST -H "Content-Type: application/json" -d "{data:{userId:\"$ADMUSR\",newPassword:\"$ADMPW\"}}" --insecure 'http://127.0.0.1:8081/nexus/service/local/users_setpw' -u "$ADMUSR":"$ADMDEFAULTPW"
  doguctl config -e "admin_password" "${ADMPW}"
  kill $!
fi
ADMPW=$(doguctl config -e "admin_password")

if ! [ -d /var/lib/nexus/plugin-repository/nexus-cas-plugin-"${CAS_PLUGIN_VERSION}" ]
  then
      echo "No cas-plugin installed"
      $START_NEXUS &
      
      if ! doguctl wait --port 8081 --timeout 120; then 
        echo "Nexus seems not to be started. Exiting."
        exit 1
      fi
  		
      # add Cas Plugin
      cp -a /opt/sonatype/nexus/resources/nexus-cas-plugin-"${CAS_PLUGIN_VERSION}"/ /var/lib/nexus/plugin-repository/
      # add mailconfig
      mailConfiguration=$(curl -H 'content-type:application/json' -H 'accept:application/json' 'http://127.0.0.1:8081/nexus/service/local/global_settings/current' -u "$ADMUSR":"$ADMPW" | jq ".data.smtpSettings+={\"host\": \"postfix\"}" | jq ".data.smtpSettings+={\"username\": \"\"}" | jq ".data.smtpSettings+={\"password\": \"\"}" | jq ".data.globalRestApiSettings+={\"baseUrl\": \"https://$FQDN/nexus/\"}" | jq ".data.smtpSettings+={\"systemEmailAddress\": \"nexus@$DOMAIN\"}" | jq ".data+={\"securityAnonymousAccessEnabled\": false}" | jq ".data+={\"securityRealms\": [\"XmlAuthenticatingRealm\",\"XmlAuthorizingRealm\",\"CasAuthenticatingRealm\"]}")
      echo "============ CONFIG INFO ============"
      echo "$mailConfiguration" | jq .
      curl --retry 3 --retry-delay 10 -H "Content-Type: application/json" -X PUT -d "$mailConfiguration" "http://127.0.0.1:8081/nexus/service/local/global_settings/current" -u "$ADMUSR":"$ADMPW"
      # disable new version info
      curl -H "Content-Type: application/json" -X PUT -d "{data:{enabled:false}}" "http://127.0.0.1:8081/nexus/service/local/lvo_config" -u "$ADMUSR":"$ADMPW"
      echo "========== CONFIG INFO END =========="
      kill $!
fi
FQDN=$(get_fqdn)
echo "render_template"
# update cas url
render_template "/opt/sonatype/nexus/resources/cas-plugin.xml.tpl" > "/var/lib/nexus/conf/cas-plugin.xml"
/configuration.sh "$ADMUSR" "$ADMPW" "$ADMINGROUP" &
exec $START_NEXUS