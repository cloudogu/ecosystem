#!/bin/bash
source /etc/ces/functions.sh
if ! [ -d /var/lib/nexus/plugin-repository/nexus-cas-plugin-1.2.2-SNAPSHOT]
  then
    echo "No cas-plugin installed"
        java \
      -server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true -Xms256m -Xmx1g \
      -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks \
      -Djavax.net.ssl.trustStorePassword=changeit \
      -Djava.awt.headless=true \
      -Dnexus-work=/var/lib/nexus -Dnexus-webapp-context-path=/nexus \
      -cp conf/:`(echo lib/*.jar) | sed -e "s/ /:/g"` \
      org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml &

      tries=0
  		while ! [ $(curl -sL -w "%{http_code}" "http://localhost:8081/nexus" -u scmadmin:scmadmin -o /dev/null) -eq 200 ]
  		do
  			((tries++))
  			echo "wait for nexus"
  			sleep 1
  			if [ $tries -gt 200 ]
  				then
  					echo "nexus didnt start"
  					echo "exit now"
  					kill $!
  					exit 1
  			fi
  		done
    mv /opt/sonatype/nexus/resources/nexus-cas-plugin-1.2.2-SNAPSHOT/ /var/lib/nexus/plugin-repository/
    kill $!
fi
FQDN=$(get_fqdn)
echo "render_template"
render_template "/opt/sonatype/nexus/resources/cas-plugin.xml.tpl" > "/var/lib/nexus/conf/cas-plugin.xml"
# add CasAuthenticatingRealm
sed -i s,'</realms>','   <realm>CasAuthenticatingRealm</realm> \n </realms>',g /var/lib/nexus/conf/security-configuration.xml
exec java \
  -server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true -Xms256m -Xmx1g \
  -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -Djava.awt.headless=true \
  -Dnexus-work=/var/lib/nexus -Dnexus-webapp-context-path=/nexus \
  -cp conf/:`(echo lib/*.jar) | sed -e "s/ /:/g"` \
  org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml
