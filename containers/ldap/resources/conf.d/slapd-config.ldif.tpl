# vim:set ft=ldif:
#
# See slapd.d(5) for details on configuration options.
# This file should NOT be world readable.
#
dn: cn=config
objectClass: olcGlobal
cn: config
olcConfigDir: ${OPENLDAP_CONFIG_DIR}
#
# Where the pid file is put. The init.d script will not stop the server if you change this.
olcPidFile: ${OPENLDAP_RUN_PIDFILE}
#
# List of arguments that were passed to the server
olcArgsFile: ${OPENLDAP_RUN_ARGSFILE}
#
# Read slapd.conf(5) for possible values
olcLogLevel: none
#
# The tool-threads parameter sets the actual amount of cpu's that is used for indexing.
olcToolThreads: 1
#
# Do not enable referrals until AFTER you have a working directory
# service AND an understanding of referrals.
#olcReferral:	ldap://root.openldap.org
#
# Sample security restrictions
#	Require integrity protection (prevent hijacking)
#	Require 112-bit (3DES or better) encryption for updates
#	Require 64-bit encryption for simple bind
#olcSecurity: ssf=1 update_ssf=112 simple_bind=64

#
# MODULES
#
dn: cn=module{0},cn=config
objectClass: olcModuleList
cn: module{0}
olcModulePath: ${OPENLDAP_MODULES_DIR}
olcModuleLoad: {0}back_${OPENLDAP_BACKEND_DATABASE}
olcModuleLoad: {1}memberof
olcModuleLoad: {2}refint

#
# SCHEMATA
#
dn: cn=schema,cn=config
objectClass: olcSchemaConfig
cn: schema

include: file://${OPENLDAP_ETC_DIR}/schema/core.ldif
include: file://${OPENLDAP_ETC_DIR}/schema/cosine.ldif
include: file://${OPENLDAP_ETC_DIR}/schema/nis.ldif
include: file://${OPENLDAP_ETC_DIR}/schema/inetorgperson.ldif

#
# FRONTEND DATABASE
#
dn: olcDatabase={-1}frontend,cn=config
objectClass: olcDatabaseConfig
objectClass: olcFrontendConfig
olcDatabase: {-1}frontend
# The maximum number of entries that is returned for a search operation
olcSizeLimit: 1000
#
# Sample global access control policy:
#	Root DSE: allow anyone to read it
#	Subschema (sub)entry DSE: allow anyone to read it
#	Other DSEs:
#		Allow self write access
#		Allow authenticated users read access
#		Allow anonymous users to authenticate
#
#olcAccess: to dn.base="" by * read
#olcAccess: to dn.base="cn=Subschema" by * read
#olcAccess: to *
#	by self write
#	by users read
#	by anonymous auth
#
# if no access controls are present, the default policy
# allows anyone and everyone to read anything but restricts
# updates to rootdn.  (e.g., "access to * by * read")
#
# rootdn can always read and write EVERYTHING!
#
# FRONTEND ACCESS
# Allow unlimited access to local connection from the local root user
olcAccess: {0}to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break
# Allow unauthenticated read access for schema and base DN autodiscovery
olcAccess: {1}to dn.exact="" by * read
olcAccess: {2}to dn.base="cn=Subschema" by * read

#
# CONFIG DATABASE
#
dn: olcDatabase=config,cn=config
objectClass: olcDatabaseConfig
olcDatabase: config
#
# Allow unlimited access to local connection from the local root user
olcAccess: to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break

#
# BACKENDS
#
dn: olcBackend=${OPENLDAP_BACKEND_DATABASE},cn=config
objectClass: olcBackendConfig
olcBackend: ${OPENLDAP_BACKEND_DATABASE}

# BACKEND DATABASE
dn: olcDatabase=${OPENLDAP_BACKEND_DATABASE},cn=config
objectClass: olcDatabaseConfig
objectClass: ${OPENLDAP_BACKEND_OBJECTCLASS}
olcDatabase: ${OPENLDAP_BACKEND_DATABASE}
olcDbCheckpoint: 512 30
olcDbConfig: set_cachesize 0 2097152 0
olcDbConfig: set_lk_max_objects 1500
olcDbConfig: set_lk_max_locks 1500
olcDbConfig: set_lk_max_lockers 1500
olcLastMod: TRUE
olcSuffix: ${OPENLDAP_SUFFIX}
olcDbDirectory: ${OPENLDAP_BACKEND_DIR}
olcRootDN: cn=admin,${OPENLDAP_SUFFIX}
olcRootPW: ${LDAP_ROOTPASS_ENC}
olcDbIndex: objectClass eq
olcDbIndex: cn pres,eq,approx,sub
olcDbIndex: uid pres,eq,approx,sub
olcDbIndex: dc pres,eq
olcDbIndex: l pres,eq
olcDbIndex: o pres,eq
olcDbIndex: mail pres,eq,approx,sub
olcDbIndex: sn pres,eq,approx,sub
# BACKEND ACCESS
## TODO - correct ADMIN USER!
olcAccess: to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break
olcAccess: to attrs=userPassword,shadowLastChange
  by self write
  by anonymous auth
  by dn="cn=admin,${OPENLDAP_SUFFIX}" write
  by dn.one=\"ou=Bind Users,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}\" read
  by dn.one=\"ou=Special Users,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}\" write
  by group/organizationalRole/roleOccupant="cn=admin,${OPENLDAP_SUFFIX}" write
  by * none
olcAccess: to dn.base="" by * read
olcAccess: to *
  by self write
  by dn="cn=admin,${OPENLDAP_SUFFIX}" write
  by group/organizationalRole/roleOccupant="cn=admin,${OPENLDAP_SUFFIX}" write
  by dn.one=\"ou=Bind Users,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}\" read
  by dn.one=\"ou=Special Users,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}\" write
  by * read

# BACKEND MEMBEROF OVERLAY
dn: olcOverlay={0}memberof,olcDatabase={1}hdb,cn=config
objectClass: olcConfig
objectClass: olcOverlayConfig
objectClass: olcMemberOf
olcOverlay: {0}memberof
olcMemberOfDangling: ignore
olcMemberOfRefInt: TRUE
olcMemberOfGroupOC: groupOfNames
olcMemberOfMemberAD: member
olcMemberOfMemberOfAD: memberOf

# BACKEND REFINT OVERLAY
dn: olcOverlay={1}refint,olcDatabase={1}hdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcRefintConfig
olcOverlay: {1}refint
olcRefintAttribute: owner
olcRefintAttribute: manager
olcRefintAttribute: uniqueMember
olcRefintAttribute: member
olcRefintAttribute: memberOf
