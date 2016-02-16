#!/bin/bash

source /etc/ces/functions.sh

LOGLEVEL=256
CONFDIR=/etc/cesldap

# LDAP ALREADY INITIALIZED?
if [ ! -f "$CONFDIR/ldap.conf"  ]; then
  mv /etc/openldap/* "$CONFDIR"
	rmdir /etc/openldap
	ln -s "$CONFDIR" /etc/openldap

  # get domain and root password
	LDAP_ROOTPASS=$(create_or_get_ces_pass ldap_root)
  LDAP_ROOTPASS_ENC=$(slappasswd -s $LDAP_ROOTPASS)
  LDAP_BASE_DOMAIN=$(get_domain)
	LDAP_DOMAIN=$(get_domain)
  # TODO passwords should not be like this
  ADMIN_USERNAME="admin"
  ADMIN_PASSWORD="$(slappasswd -s admin)"
  SYSTEM_USERNAME="system"
  SYSTEM_PASSWORD="$(slappasswd -s system)"
  ROOTDN="cn=admin,dc=cloudogu,dc=com"
  SUFFIX="dc=cloudogu,dc=com"

  # GENERATE SLAPD.LDIF AND SLAPD.CONF
  render_template "/resources/slapd.conf.tpl" > "/etc/openldap/slapd.conf"
  render_template "/resources/slapd.ldif.tpl" > "/etc/openldap/slapd.ldif"

  # START LDAP IN BACKGROUND
	/usr/sbin/slapd -h "ldap:/// ldapi:///" -4 -u ldap -g ldap -d $LOGLEVEL &
  sleep 2

  # ENABLE MEMBEROF
  ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /resources/memberof-overlay.ldif
  ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /resources/refint.ldif

  # INDEX ATTRIBUTES
  ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /resources/index.ldif

  # restart
  kill -INT $!
  sleep 1
  /usr/sbin/slapd -h "ldap:/// ldapi:///" -4 -u ldap -g ldap -d $LOGLEVEL &
  sleep 2

  # ADD STRUCTURE
  render_template "/resources/domain.ldif.tpl" > "/resources/domain.ldif"
	ldapadd -D"$ROOTDN" -x -w"${LDAP_ROOTPASS}" -f "/resources/domain.ldif"
  wait
  # WILL THERE BE USERS?
else
  # START LDAP
  /usr/sbin/slapd -h "ldap:///" -4 -u ldap -g ldap -d $LOGLEVEL
fi
