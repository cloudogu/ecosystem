[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = DE
ST = Lower Saxony
L = Brunswick
O = ${DOMAIN}
OU = ${DOMAIN}
CN = ${FQDN}

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
IP = ${IP}
DNS.1 = ${IP}
