#!/bin/bash
source /etc/ces/functions.sh
ADMUSR="admin"
ADMPW="admin123"
ADMINGROUP=$(get_config admin_group)
DOMAIN=$(get_config domain)


START_NEXUS="java \
  -server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true -Xms256m -Xmx1g \
  -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -Djava.awt.headless=true \
  -Dnexus-work=/var/lib/nexus -Dnexus-webapp-context-path=/nexus \
  -cp conf/:`(echo lib/*.jar) | sed -e "s/ /:/g"` \
  org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml"

if ! [ -d /var/lib/nexus/plugin-repository/nexus-cas-plugin-${CAS_PLUGIN_VERSION} ]
  then
      echo "No cas-plugin installed"
      $START_NEXUS &
      tries=0
  		while ! [ $(curl -sL -w "%{http_code}" "http://localhost:8081/nexus" -u $ADMUSR:$ADMPW -o /dev/null) -eq 200 ]
  		do
  			((tries++))
  			echo "wait for nexus (cas-plugin)"
  			sleep 1
  			if [ $tries -gt 200 ]
  				then
  					echo "nexus didnt start"
  					echo "exit now"
  					kill $!
  					exit 1
  			fi
  	  done
      # add Cas Pluin
      cp -a /opt/sonatype/nexus/resources/nexus-cas-plugin-${CAS_PLUGIN_VERSION}/ /var/lib/nexus/plugin-repository/
      # add mailconfig
      mailConfiguration=$(curl -H 'content-type:application/json' -H 'accept:application/json' 'http://127.0.0.1:8081/nexus/service/local/global_settings/current' -u "$ADMUSR":"$ADMPW" | jq ".data.smtpSettings+={\"host\": \"postfix\"}" | jq ".data.smtpSettings+={\"username\": \"\"}" | jq ".data.smtpSettings+={\"password\": \"\"}" | jq ".data.smtpSettings+={\"systemEmailAddress\": \"nexus@$DOMAIN\"}" | jq ".data+={\"securityAnonymousAccessEnabled\": false}" | jq ".data+={\"securityRealms\": [\"CasAuthenticatingRealm\",\"XmlAuthenticatingRealm\",\"XmlAuthorizingRealm\"]}")
      echo "============ CONFIG INFO ============"
      echo $mailConfiguration | jq .
      curl -H "Content-Type: application/json" -X PUT -d "$mailConfiguration" "http://127.0.0.1:8081/nexus/service/local/global_settings/current" -u "$ADMUSR":"$ADMPW"
      echo "========== CONFIG INFO END =========="
      kill $!
fi
FQDN=$(get_fqdn)
echo "render_template"
render_template "/opt/sonatype/nexus/resources/cas-plugin.xml.tpl" > "/var/lib/nexus/conf/cas-plugin.xml"
/groupMapping.sh $ADMUSR $ADMPW $ADMINGROUP &
exec $START_NEXUS
