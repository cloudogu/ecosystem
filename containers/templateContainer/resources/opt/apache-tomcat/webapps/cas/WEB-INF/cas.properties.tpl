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
server.name=${SERVERNAME}
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
host.name=scmm-universe

##
# Database flavors for Hibernate
#
# One of these is needed if you are storing Services or Tickets in an RDBMS via JPA.
#
# database.hibernate.dialect=org.hibernate.dialect.OracleDialect
database.hibernate.dialect=org.hibernate.dialect.MySQLInnoDBDialect
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

# == Database settings ==

db.url=jdbc:mysql://localhost:3306/cas?autoReconnect=true
db.password=cas
db.username=cas


# ==================================
# == LDAP Authentication settings ==
# ==================================
#Example: sAMAccountName=%u
ldap.authentication.filter=uid=%u

#Comma-separated list of server urls (i.e. ldap://1.2.3.4)
ldap.authentication.server.urls=ldap:\/\/127.0.0.1:389

ldap.authentication.server.anonymousReadOnly=true

#Ldap Base DNs based on the context for query execution (i.e. cn=users,dc=school,dc=edu)
ldap.authentication.basedn=dc=scm-manager,dc=local

#Ldap mapping of result attributes
ldap.authentication.attribute.username=uid
ldap.authentication.attribute.cn=cn
ldap.authentication.attribute.mail=mail
ldap.authentication.attribute.givenName=givenName
ldap.authentication.attribute.surname=sn
ldap.authentication.attribute.displayName=displayName
ldap.authentication.attribute.groups=ou

#Manager credentials to bind (i.e. cn=manager,cn=users,dc=school,dc=edu/password)
ldap.authentication.manager.userdn=
ldap.authentication.manager.password=

#Ignore the exception if LDAP query returned more than one item
ldap.authentication.ignorePartialResultException=true

ldap.authentication.jndi.connect.timeout=3000
ldap.authentication.jndi.read.timeout=3000
ldap.authentication.jndi.security.level=simple

# == LDAP Context Pooling settings ==

ldap.authentication.pool.minIdle=3
ldap.authentication.pool.maxIdle=5
ldap.authentication.pool.maxSize=10

# Maximum time in ms to wait for connection to become available
# under pool exhausted condition.
ldap.authentication.pool.maxWait=10000

# == Evictor configuration ==

# Period in ms at which evictor process runs.
ldap.authentication.pool.evictionPeriod=600000

# Maximum time in ms at which connections can remain idle before
# they become liable to eviction.
ldap.authentication.pool.idleTime=1200000

# == Connection testing settings ==

# Set to true to enable connection liveliness testing on evictor
# process runs.  Probably results in best performance.
ldap.authentication.pool.testWhileIdle=true

# Set to true to enable connection liveliness testing before every
# request to borrow an object from the pool.
ldap.authentication.pool.testOnBorrow=false

# ======================================================
# == LDAP Password Policy Enforcement (LPPE) settings ==
# ======================================================

#Warn all users of expiration date regardless of warningDays value
ldap.authentication.lppe.warnAll=false

#Date format for value from dateAttribute see http://java.sun.com/j2se/1.4.2/docs/api/java/text/SimpleDateFormat.html
#Change value to 'ActiveDirectory' or 'AD' when using AD
#ldap.authentication.lppe.dateFormat=yyyyMMddHHmmss'Z'
ldap.authentication.lppe.dateFormat=yyyyMMddHHmmss'Z'

#LDAP attribute that stores the last password change time
#Change value to 'pwdlastset' or 'lastlogon' when using AD
#ldap.authentication.lppe.dateAttribute=passwordchangedtime
#ldap.authentication.lppe.dateAttribute=accountExpires

#The attribute that contains the data that will determine if password warning is skipped
#ldap.authentication.lppe.noWarnAttribute=

#The list of values that will cause password warning to be bypassed
#If the value retrieved for the attribute above matches the elements defined below, password warning will be bypassed.
#LPPE automatically checks for 'never' used by ActiveDirectory
#ldap.authentication.lppe.noWarnValues=

#LDAP attribute that stores the user's personal setting for the number of days to warn before expiration
#ldap.authentication.lppe.warningDaysAttribute=passwordwarningdays

#LDAP attribute that stores the custom setting for the number of days a password is valid
#ldap.authentication.lppe.validDaysAttribute=passwordexpiredays
#ldap.authentication.lppe.validDaysAttribute=maxPwdAge

#Default value used if warningDaysAttribute is not found
ldap.authentication.lppe.warningDays=30

#Default value used if validDaysAttribute is not found
ldap.authentication.lppe.validDays=90

#Url to which the user will be redirected to change the passsword
#ldap.authentication.lppe.password.url=https://password.example.edu/change
