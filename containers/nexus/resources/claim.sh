#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

if ! doguctl wait --port 8081 --timeout 120; then 
  echo "Nexus seems not to be started. Exiting."
  exit 1
fi

ONCE_LOCK="/var/lib/nexus/claim.once"

export NEXUS_USER="admin"
export NEXUS_PASSWORD=$(doguctl config -e "admin_password")

function claim() {
  CLAIM="${1}"
  LOCK="${2}"
  PLAN=$(mktemp)
  if doguctl config claim/"${CLAIM}" > "${PLAN}"; then
    echo "exec claim ${CLAIM}"
    nexus-claim plan -i "${PLAN}" -o "-" | nexus-claim apply -i "-"

    if [ "${LOCK}" != "" ]; then
      echo 1 > "${ONCE_LOCK}"
    fi
  fi
  rm -f "${PLAN}"
}

function claim_once() {
  claim "once" "${ONCE_LOCK}"
}

function claim_always() {
  claim "always" ""
}

if [ ! -f "${ONCE_LOCK}" ]; then
  claim_once
fi

claim_always
