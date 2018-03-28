#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# variables
ADMUSR="admin"
ADMDEFAULTPW="admin123"
ADMINGROUP=$(doguctl config --global admin_group)
DOMAIN=$(doguctl config --global domain)
MAIL_ADDRESS=$(doguctl config -d "nexus@${DOMAIN}" --global mail_address)
FQDN=$(doguctl config --global fqdn)

function set_random_admin_password {
  ADMPW=$(doguctl random)
  curl -s --retry 3 --retry-delay 10 -X POST -H "Content-Type: application/json" -d "{data:{userId:\"$ADMUSR\",newPassword:\"$ADMPW\"}}" --insecure 'http://127.0.0.1:8081/nexus/service/local/users_setpw' -u "$ADMUSR":"$ADMDEFAULTPW"
  doguctl config -e "admin_password" "${ADMPW}"
  echo "${ADMPW}"
}

function render_template(){
  FILE="$1"
  if [ ! -f "$FILE" ]; then
    echo >&2 "could not find template $FILE"
    exit 1
  fi

  # render template
  eval "echo \"$(cat $FILE)\""
}

function setProxyConfiguration(){
  NEXUS_CONFIGURATION=$(curl -s -H 'content-type:application/json' -H 'accept:application/json' 'http://127.0.0.1:8081/nexus/service/local/global_settings/current' -u "$ADMUSR":"$ADMPW")
  # Write proxy settings if enabled in etcd
  if [ "true" == "$(doguctl config --global proxy/enabled)" ]; then
    if PROXYSERVER=$(doguctl config --global proxy/server) && PROXYPORT=$(doguctl config --global proxy/port); then
      writeProxyCredentialsTo "${NEXUS_CONFIGURATION}"
      if PROXYUSER=$(doguctl config --global proxy/username) && PROXYPASSWORD=$(doguctl config --global proxy/password); then
        writeProxyAuthenticationCredentialsTo "${NEXUS_CONFIGURATION}"
      else
        echo "Proxy authentication credentials are incomplete or not existent."
      fi
      putNexusConfiguration
    else
      echo "Proxy server or port configuration missing in etcd."
    fi
  else
    PROXYSERVER=""
    PROXYPORT=0
    PROXYUSER=""
    PROXYPASSWORD=""
    writeProxyCredentialsTo "${NEXUS_CONFIGURATION}"
    writeProxyAuthenticationCredentialsTo "${NEXUS_CONFIGURATION}"
    putNexusConfiguration
  fi
}

function writeProxyCredentialsTo(){
  NEXUS_CONFIGURATION=$(echo "$1" | jq ".data.remoteProxySettings.httpProxySettings+={\"proxyHostname\": \"${PROXYSERVER}\"}")
  NEXUS_CONFIGURATION=$(echo "${NEXUS_CONFIGURATION}" | jq ".data.remoteProxySettings.httpProxySettings+={\"proxyPort\": ${PROXYPORT}}")
}

function writeProxyAuthenticationCredentialsTo(){
  # Add proxy authentication credentials
  NEXUS_CONFIGURATION=$(echo "$1" | jq ".data.remoteProxySettings.httpProxySettings.authentication+={\"username\": \"${PROXYUSER}\"}")
  NEXUS_CONFIGURATION=$(echo "${NEXUS_CONFIGURATION}" | jq ".data.remoteProxySettings.httpProxySettings.authentication+={\"password\": \"${PROXYPASSWORD}\"}")
}

function putNexusConfiguration(){
  curl -s --retry 3 --retry-delay 10 -H "Content-Type: application/json" -X PUT -d "${NEXUS_CONFIGURATION}" "http://127.0.0.1:8081/nexus/service/local/global_settings/current" -u "$ADMUSR":"$ADMPW"
}

function startNexusAndWaitForHealth(){
  $START_NEXUS &
  if ! doguctl wait --port 8081 --timeout 120; then
    echo "Nexus seems not to be started. Exiting."
    exit 1
  fi
}

doguctl state installing

# create truststore
TRUSTSTORE="/var/lib/nexus/truststore.jks"
create_truststore.sh "${TRUSTSTORE}" > /dev/null

START_NEXUS="java \
  -server -Djava.net.preferIPv4Stack=true -Xms256m -Xmx1g \
  -Djavax.net.ssl.trustStore=${TRUSTSTORE} \
	-Djavax.net.ssl.trustStorePassword=changeit \
  -Dnexus-work=/var/lib/nexus -Dnexus-webapp-context-path=/nexus \
  -cp conf/:$(echo lib/*.jar | sed -e "s/ /:/g") \
  org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml"

if ! [ -d /var/lib/nexus/plugin-repository/nexus-cas-plugin-"${CAS_PLUGIN_VERSION}" ]; then
      echo "No cas-plugin installed"

      startNexusAndWaitForHealth

      ADMPW=$(set_random_admin_password)

      # add cas Plugin
      cp -dR /opt/sonatype/nexus/resources/nexus-cas-plugin-"${CAS_PLUGIN_VERSION}"/ /var/lib/nexus/plugin-repository/
      # add mailconfig
      MAIL_CONFIGURATION=$(curl -s -H 'content-type:application/json' -H 'accept:application/json' 'http://127.0.0.1:8081/nexus/service/local/global_settings/current' -u "$ADMUSR":"$ADMPW" | jq ".data.smtpSettings+={\"host\": \"postfix\"}" | jq ".data.smtpSettings+={\"username\": \"\"}" | jq ".data.smtpSettings+={\"password\": \"\"}" | jq ".data.globalRestApiSettings+={\"baseUrl\": \"https://$FQDN/nexus/\"}" | jq ".data.smtpSettings+={\"systemEmailAddress\": \"${MAIL_ADDRESS}\"}" | jq ".data+={\"securityAnonymousAccessEnabled\": false}" | jq ".data+={\"securityRealms\": [\"XmlAuthenticatingRealm\",\"XmlAuthorizingRealm\",\"CasAuthenticatingRealm\"]}")
      curl -s --retry 3 --retry-delay 10 -H "Content-Type: application/json" -X PUT -d "$MAIL_CONFIGURATION" "http://127.0.0.1:8081/nexus/service/local/global_settings/current" -u "$ADMUSR":"$ADMPW"
      # disable new version info
      curl -s -H "Content-Type: application/json" -X PUT -d "{data:{enabled:false}}" "http://127.0.0.1:8081/nexus/service/local/lvo_config" -u "$ADMUSR":"$ADMPW"
      kill $!
fi

if  ! doguctl config -e "admin_password" > /dev/null ; then
  startNexusAndWaitForHealth
  set_random_admin_password
  kill $!
fi

ADMPW=$(doguctl config -e "admin_password")

startNexusAndWaitForHealth
setProxyConfiguration
kill $!

echo "render_template"
# update cas url
render_template "/opt/sonatype/nexus/resources/cas-plugin.xml.tpl" > "/var/lib/nexus/conf/cas-plugin.xml"

/configuration.sh "$ADMUSR" "$ADMPW" "$ADMINGROUP" &
/claim.sh &

doguctl state ready
exec $START_NEXUS
