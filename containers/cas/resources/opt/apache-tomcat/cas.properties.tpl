#
# Licensed to Jasig under one or more contributor license
# agreements. See the NOTICE file distributed with this work
# for additional information regarding copyright ownership.
# Jasig licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file
# except in compliance with the License.  You may obtain a
# copy of the License at the following location:
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

##
# Services Management Web UI Security
server.name=https://%FQDN%
server.prefix=${server.name}/cas
cas.securityContext.serviceProperties.service=${server.prefix}/services/j_acegi_cas_security_check
# Names of roles allowed to access the CAS service manager
cas.securityContext.serviceProperties.adminRoles=ROLE_ADMIN
cas.securityContext.casProcessingFilterEntryPoint.loginUrl=${server.prefix}/login
cas.securityContext.ticketValidator.casServerUrlPrefix=${server.prefix}
# IP address or CIDR subnet allowed to access the /status URI of CAS that exposes health check information
cas.securityContext.status.allowedSubnet=127.0.0.1


cas.themeResolver.defaultThemeName=cas-theme-scmm-universe
cas.viewResolver.basename=default_views

##
# Unique CAS node name
# host.name is used to generate unique Service Ticket IDs and SAMLArtifacts.  This is usually set to the specific
# hostname of the machine running the CAS node, but it could be any label so long as it is unique in the cluster.
host.name=cas.%DOMAIN%

##
# Database flavors for Hibernate
#
# One of these is needed if you are storing Services or Tickets in an RDBMS via JPA.
#
# database.hibernate.dialect=org.hibernate.dialect.OracleDialect
# database.hibernate.dialect=org.hibernate.dialect.MySQLInnoDBDialect
# database.hibernate.dialect=org.hibernate.dialect.HSQLDialect

##
# CAS Logout Behavior
# WEB-INF/cas-servlet.xml
#
# Specify whether CAS should redirect to the specifyed service parameter on /logout requests
# cas.logout.followServiceRedirects=false

##
# Single Sign-On Session Timeouts
# Defaults sourced from WEB-INF/spring-configuration/ticketExpirationPolices.xml
#
# Maximum session timeout - TGT will expire in maxTimeToLiveInSeconds regardless of usage
# tgt.maxTimeToLiveInSeconds=28800
#
# Idle session timeout -  TGT will expire sooner than maxTimeToLiveInSeconds if no further requests
# for STs occur within timeToKillInSeconds
# tgt.timeToKillInSeconds=7200

##
# Service Ticket Timeout
# Default sourced from WEB-INF/spring-configuration/ticketExpirationPolices.xml
#
# Service Ticket timeout - typically kept short as a control against replay attacks, default is 10s.  You'll want to
# increase this timeout if you are manually testing service ticket creation/validation via tamperdata or similar tools
# st.timeToKillInSeconds=10

##
# Single Logout Out Callbacks
# Default sourced from WEB-INF/spring-configuration/argumentExtractorsConfiguration.xml
#
# To turn off all back channel SLO requests set slo.disabled to true
# slo.callbacks.disabled=false

##
# Service Registry Periodic Reloading Scheduler
# Default sourced from WEB-INF/spring-configuration/applicationContext.xml
#
# Force a startup delay of 2 minutes.
# service.registry.quartz.reloader.startDelay=120000
#
# Reload services every 2 minutes
# service.registry.quartz.reloader.repeatInterval=120000

##
# Log4j
# Default sourced from WEB-INF/spring-configuration/log4jConfiguration.xml:
#
# It is often time helpful to externalize log4j.xml to a system path to preserve settings between upgrades.
# e.g. log4j.config.location=/etc/cas/log4j.xml
# log4j.config.location=classpath:log4j.xml
#
# log4j refresh interval in millis
# log4j.refresh.interval=60000


# ==================================
# == LDAP Authentication settings ==
# ==================================

#========================================
# General properties
#========================================
ldap.url=%LDAP_PROTOCOL%://%LDAP_HOST%:%LDAP_PORT%

# LDAP connection timeout in milliseconds
ldap.connectTimeout=3000

# Whether to use StartTLS (probably needed if not SSL connection)
ldap.useStartTLS=%LDAP_STARTTLS%

#========================================
# LDAP connection pool configuration
#========================================
ldap.pool.minSize=3
ldap.pool.maxSize=10
ldap.pool.validateOnCheckout=false
ldap.pool.validatePeriodically=true

# Amount of time in milliseconds to block on pool exhausted condition
# before giving up.
ldap.pool.blockWaitTime=3000

# Frequency of connection validation in seconds
# Only applies if validatePeriodically=true
ldap.pool.validatePeriod=300

# Attempt to prune connections every N seconds
ldap.pool.prunePeriod=300

# Maximum amount of time an idle connection is allowed to be in
# pool before it is liable to be removed/destroyed
ldap.pool.idleTime=600

#========================================
# Authentication
#========================================

# Base DN of users to be authenticated
ldap.authn.baseDn=%LDAP_BASE_DN%

# Manager DN for authenticated searches
ldap.authn.managerDN=%LDAP_BIND_DN%

# Manager password for authenticated searches
ldap.authn.managerPassword=%LDAP_BIND_PASSWORD%

# Search filter used for configurations that require searching for DNs
#ldap.authn.searchFilter=(&(uid={user})(accountState=active))
ldap.authn.searchFilter=%LDAP_SEARCH_FILTER%

# Search filter used for configurations that require searching for DNs
#ldap.authn.format=uid=%s,ou=Users,dc=example,dc=org
ldap.authn.format=uid=%s,ou=Accounts,%LDAP_BASE_DN%

#Ldap mapping of result attributes
ldap.authn.attribute.username=%LDAP_ATTRIBUTE_USERNAME%
ldap.authn.attribute.cn=cn
ldap.authn.attribute.mail=%LDAP_ATTRIBUTE_MAIL%
ldap.authn.attribute.givenName=givenName
ldap.authn.attribute.surname=sn
ldap.authn.attribute.displayName=displayName
ldap.authn.attribute.groups=%LDAP_ATTRIBUTE_GROUP%

# member search settings

# settings for ldap group search by member
# base dn for group search e.g.: o=ces.local,dc=cloudogu,dc=com
ldap.authn.groups.baseDn=%LDAP_GROUP_BASE_DN%

# search filter for group search {0} will be replaced with the dn of the user
# e.g.: (member={0})
# if this property is empty, group search by member will be skipped
ldap.authn.groups.searchFilter=%LDAP_GROUP_SEARCH_FILTER%

# name attribute of groups e.g.: cn
ldap.authn.groups.attribute.name=%LDAP_GROUP_ATTRIBUTE_NAME%

# use the connection after bind with user dn to fetch attributes
ldap.authn.useUserConnectionToFetchAttributes = %LDAP_USE_USER_CONNECTION%

ldap.trustManager=%LDAP_TRUST_MANAGER%
# set deployment stage
stage = %STAGE%
requireSecure = %REQUIRE_SECURE%

#========================================
# Limit Login Attempts
#========================================
# set login.limit.maxNumber to 0 to disable feature
# time parameters are configured in seconds
login.limit.maxNumber=%LOGIN_LIMIT_MAX_NUMBER%
login.limit.failureStoreTime=%LOGIN_LIMIT_FAILURE_STORE_TIME%
login.limit.lockTime=%LOGIN_LIMIT_LOCK_TIME%
login.limit.maxAccounts=10000
