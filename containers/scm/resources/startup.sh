#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

INIT_SCRIPT_FOLDER="/opt/scm-server/init.script.d"
MAIN_INIT_SCRIPTS_FOLDER="/var/tmp/scm/init.script.d"
CUSTOM_INIT_SCRIPTS_FOLDER="/var/lib/custom.init.script.d"

# remove old folder to be sure, 
# that it contains no script which is already removed from custom init script folder
if [ -d "${INIT_SCRIPT_FOLDER}" ]; then
  rm -rf "${INIT_SCRIPT_FOLDER}"
fi

# copy fresh main init scripts
cp -rf "${MAIN_INIT_SCRIPTS_FOLDER}" "${INIT_SCRIPT_FOLDER}"

# merge custom init scripts, if the volume is not empty
if [ "$(ls -A ${CUSTOM_INIT_SCRIPTS_FOLDER})" ]; then
  cp "${CUSTOM_INIT_SCRIPTS_FOLDER}"/* "${INIT_SCRIPT_FOLDER}"
fi

# create truststore, which is used in the default file
create_truststore.sh /opt/scm-server/conf/truststore.jks > /dev/null

# create ca certificate store for mercurial
create-ca-certificates.sh /opt/scm-server/conf/ca-certificates.crt

if ! [ -d "/var/lib/scm/config" ];  then
	mkdir -p "/var/lib/scm/config"
fi

# Final startup
exec /opt/scm-server/bin/scm-server
