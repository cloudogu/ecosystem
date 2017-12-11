#!/bin/bash

DIRECTORY="/etc/ssl"
STORE="${1:-$DIRECTORY/truststore.jks}"
STOREPASS="changeit"
CERTALIAS="ces"

function create(){
  # create ssl directory
  if [ ! -d "$DIRECTORY" ]; then
    mkdir "$DIRECTORY"
  fi

  # read certificate from etcd
  CERTIFICATE="$(mktemp)"
  doguctl config --global certificate/server.crt > "${CERTIFICATE}"

  cp "${JAVA_HOME}/jre/lib/security/cacerts" "${STORE}"
  # cacerts keystore is readonly in alpine package
  chmod 644 "${STORE}"
  keytool -keystore "${STORE}" -storepass "${STOREPASS}" -alias "${CERTALIAS}" \
    -import -file "${CERTIFICATE}" -noprompt

  # cleanup temp files
  rm -f "${CERTIFICATE}"
}

create 2> /dev/null
echo "-Djavax.net.ssl.trustStore=${STORE} -Djavax.net.ssl.trustStorePassword=${STOREPASS}"
