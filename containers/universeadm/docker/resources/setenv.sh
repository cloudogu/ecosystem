#!/bin/sh
UNIVERSEADM_HOME="/var/lib/universeadm/conf"
JAVA_OPTS="$JAVA_OPTS -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks"
JAVA_OPTS="$JAVA_OPTS -Djavax.net.ssl.trustStorePassword=changeit"
