#
# LDAP Defaults
#

# See ldap.conf(5) for details
# This file should be world readable but not world writable.

#BASE   ${OPENLDAP_SUFFIX}
URI    ldapi://

#SIZELIMIT  12
#TIMELIMIT  15
#DEREF      never

# TLS certificates (needed for GnuTLS)
#TLS_CACERT  /etc/ssl/certs/ca-certificates.crt
