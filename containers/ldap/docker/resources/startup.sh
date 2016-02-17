#!/bin/bash -e
source /etc/ces/functions.sh

# based on https://github.com/dweomer/dockerfiles-openldap/blob/master/openldap.sh

LOGLEVEL=${LOGLEVEL:-0}

OPENLDAP_ETC_DIR="/etc/openldap"
OPENLDAP_RUN_DIR="/var/run/openldap"
OPENLDAP_RUN_ARGSFILE="${OPENLDAP_RUN_DIR}/slapd.args"
OPENLDAP_RUN_PIDFILE="${OPENLDAP_RUN_DIR}/slapd.pid"
OPENLDAP_MODULES_DIR="/usr/lib/openldap"
OPENLDAP_CONFIG_DIR="${OPENLDAP_ETC_DIR}/slapd.d"
OPENLDAP_BACKEND_DIR="/var/lib/openldap"
OPENLDAP_BACKEND_DATABASE="hdb"
OPENLDAP_BACKEND_OBJECTCLASS="olcHdbConfig"
OPENLDAP_ULIMIT="2048"

ulimit -n ${OPENLDAP_ULIMIT}

# LDAP ALREADY INITIALIZED?
if [[ ! -d ${OPENLDAP_CONFIG_DIR}/cn=config ]]; then

  # remove default configuration
  rm -f ${OPENLDAP_ETC_DIR}/*.conf

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

  # TODO: PLEASE CHECK IF NECCESSARY
  ROOTDN="cn=admin,dc=cloudogu,dc=com"
  SUFFIX="dc=cloudogu,dc=com"

  mkdir -p ${OPENLDAP_CONFIG_DIR}

  if [[ ! -s ${OPENLDAP_ETC_DIR}/ldap.conf ]]; then
    render_template /srv/openldap/conf.d/ldap.conf.tpl > ${OPENLDAP_ETC_DIR}/ldap.conf
  fi

  if [[ ! -s ${OPENLDAP_ETC_DIR}/slapd-config.ldif ]]; then
    render_template /srv/openldap/conf.d/slapd-config.ldif.tpl > ${OPENLDAP_ETC_DIR}/slapd-config.ldif
  fi

  slapadd -n0 -F ${OPENLDAP_CONFIG_DIR} -l ${OPENLDAP_ETC_DIR}/slapd-config.ldif > ${OPENLDAP_ETC_DIR}/slapd-config.ldif.log

  mkdir -p ${OPENLDAP_BACKEND_DIR}/run
  chown -R ldap:ldap ${OPENLDAP_BACKEND_DIR}
  chown -R ldap:ldap ${OPENLDAP_CONFIG_DIR} ${OPENLDAP_BACKEND_DIR}

  if [[ -d /srv/openldap/ldif.d ]]; then
    for f in $(find /srv/openldap/ldif.d -type f -name "*.tpl"); do
      render_template $f > $(echo $f | sed 's/\.tpl//g')
    done

    slapd_exe=$(which slapd)
    echo >&2 "$0 ($slapd_exe): starting initdb daemon"
    slapd -u ldap -g ldap -h ldapi:///

    for f in $(find /srv/openldap/ldif.d -type f -name "*.ldif" | sort); do
      echo >&2 "applying $f"
      ldapadd -Y EXTERNAL -f "$f" 2>&1
    done

    if [[ ! -s ${OPENLDAP_RUN_PIDFILE} ]]; then
      echo >&2 "$0 ($slapd_exe): ${OPENLDAP_RUN_PIDFILE} is missing, did the daemon start?"
      exit 1
    else
      slapd_pid=$(cat ${OPENLDAP_RUN_PIDFILE})
      echo >&2 "$0 ($slapd_exe): sending SIGINT to initdb daemon with pid=$slapd_pid"
      kill -s INT "$slapd_pid" || true
      while : ; do
        [[ ! -f ${OPENLDAP_RUN_PIDFILE} ]] && break
        sleep 1
        echo >&2 "$0 ($slapd_exe): initdb daemon is still up, sleeping ..."
      done
      echo >&2 "$0 ($slapd_exe): initdb daemon stopped"
    fi
  fi
fi

/usr/sbin/slapd -h "ldapi:/// ldap:///" -u ldap -g ldap -d $LOGLEVEL
