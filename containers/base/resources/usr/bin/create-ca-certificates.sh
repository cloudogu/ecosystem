#!/bin/bash

DIRECTORY="/etc/ssl"
STORE="${1:-$DIRECTORY/ca-certificates.crt}"

# create ssl directory
if [ ! -d "$DIRECTORY" ]; then
  mkdir "$DIRECTORY"
fi

CERTIFICATE="$(mktemp)"
doguctl config --global certificate/server.crt > "${CERTIFICATE}"
cat /etc/ssl/certs/ca-certificates.crt "${CERTIFICATE}" > "${STORE}"

# cleanup temp files
rm -f "${CERTIFICATE}"
