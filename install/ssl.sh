#!/bin/bash
source /etc/ces/functions.sh

# enable strict mode
set -eo pipefail
IFS=$'\n\t'

source /etc/environment
export PATH

# variables
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)
IP=$(get_ip)

echo "create self sigined certificate for fqdn ${FQDN}"

# create temporary directoy
SSL_DIR=$(mktemp)
rm -f "${SSL_DIR}"
mkdir -p "${SSL_DIR}"

# create variables
SSL_CONF="${SSL_DIR}/openssl.conf"
CERTIFICATE="${SSL_DIR}/server.crt"
KEY="${SSL_DIR}/server.key"
CAKEY="${SSL_DIR}/ca.key"
CA="${SSL_DIR}/ca.pem"
CSR="${SSL_DIR}/server.csr"
SIGNED="${SSL_DIR}/server.signed"
CA_DIR="${SSL_DIR}/ca"

CN="CES Self Signed"

function render_openssl_config() {
  # render template for ssl configuration
  render_template "/etc/ces/ssl.conf.tpl" > "${SSL_CONF}"

  # if fqdn is an ip add alternative name
  if [[ $FQDN =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "IP = ${IP}" >> "${SSL_CONF}"
  fi
}

render_openssl_config

# create passphrase
PASSPHRASE=$(openssl rand -hex 16)

# create ca key
openssl genrsa -aes256 -passout pass:${PASSPHRASE} -out "${CAKEY}" 2048 2>/dev/null

# create ca
openssl req -x509 -new -passin pass:${PASSPHRASE} -extensions v3_ca -key "${CAKEY}" -days 3650 -out "${CA}" -sha512 -config "${SSL_CONF}" 2>/dev/null

# rerender ssl configuration to change CN
CN="${FQDN}"
render_openssl_config

# create server key, request and certificate
openssl genrsa -out "${KEY}" 4096 2>/dev/null
openssl req -new -nodes -key "${KEY}" -out "${CSR}" -config "${SSL_CONF}" -sha512 2>/dev/null

# create ca database
mkdir -p "${CA_DIR}/certs" "${CA_DIR}/newcerts"
touch "${CA_DIR}/index.txt" "${CA_DIR}/.rand"
date +%s > ${CA_DIR}/serial

# sign request
openssl ca -batch -config "${SSL_CONF}" -passin pass:${PASSPHRASE} -policy policy_anything -out "${SIGNED}" -in "${CSR}" 2>/dev/null

# extract certificate
openssl x509 -in "${SIGNED}" -out "${CERTIFICATE}"

# add ca to certificate
cat "${CA}" >> "${CERTIFICATE}"

# write certificate to etcd
etcdctl --peers "$(cat /etc/ces/node_master):4001" set /config/_global/certificate/type selfsigned > /dev/null
cat "${CERTIFICATE}" | etcdctl --peers "$(cat /etc/ces/node_master):4001" set /config/_global/certificate/server.crt > /dev/null
cat "${KEY}" | etcdctl --peers "$(cat /etc/ces/node_master):4001" set /config/_global/certificate/server.key > /dev/null

# remove temporary files
rm -rf "${SSL_DIR}"
