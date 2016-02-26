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
ldap.url=ldap://%LDAP_HOST%:%LDAP_PORT%

# LDAP connection timeout in milliseconds
ldap.connectTimeout=3000

# Whether to use StartTLS (probably needed if not SSL connection)
ldap.useStartTLS=false

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
ldap.authn.searchFilter=(&(objectClass=person)(uid={user}))

# Search filter used for configurations that require searching for DNs
#ldap.authn.format=uid=%s,ou=Users,dc=example,dc=org
ldap.authn.format=uid=%s,ou=People,%LDAP_BASE_DN%

#Ldap mapping of result attributes
ldap.authn.attribute.username=uid
ldap.authn.attribute.cn=cn
ldap.authn.attribute.mail=mail
ldap.authn.attribute.givenName=givenName
ldap.authn.attribute.surname=sn
ldap.authn.attribute.displayName=displayName
ldap.authn.attribute.groups=memberOf
