# Automating the Cloudogu EcoSystem Setup Process
The setup mechanism of the Cloudogu EcoSystem can be performed in different ways. One way is to provide all necessary data and set all options via the web interface. Another way is to create a file called **setup.json** which contains some or all configuration data needed. This file has to be placed into the ``/vagrant`` or ``/etc/ces`` folder and needs to be formatted in JSON. All data defined in that file will be automatically inserted into the corresponding setup web interface fields. If the entire configuration of the setup is present, the setup can be done fully automatically by setting all *"completed"*-values to `true` (see below) if the registration step is done before.

Example:
````
{
  "region": {
    "completed": true,
    "locale": "en_US.utf8",
    "timeZone": "Europe/Berlin"
  },
  "dogus":{
    "defaultDogu":"cockpit",
    "install":[
      "official/cas",
      "official/cockpit",
      "official/jenkins",
      "official/usermgt"
    ]
  },
  "admin": {
    "username": "admin",
    "mail": "admin@testdomain.com",
    "adminGroup": "Administrators",
  }
}
````

The setup.json file consists of objects named after the corresponding setup step (e.g. 'region' or 'admin'). These objects contain properties describing the configuration of this setup step. If the *"completed"* property is set to `true`, all properties for this step are accepted and the step will not show up during the setup process in the web interface.

Besides these configuration steps that represent a similar setup step, the setup.json provides advanced configuration options that are not accessible or settable trough the web setup process. All possible configuration is shown below, ordered by configuration type.

## Setup configuration steps

### Section 'region'
Object name: _region_

Properties:

#### locale
* Data type: String
* Content: locale settings of the EcoSystem
* Example: `"en_US.utf8"`


#### timeZone
* Data type: String
* Content: Timezone of the EcoSystem
* Example: `"Europe/Berlin"`

#### keyboardLayout

- Data type: String
- Content: Keyboard layout for CES instance
- Example: `"de"`

#### completed
* Data type: boolean
* Content: Logical value which shows if the *region step* is completely finished
* Example: `true`


### Step 'naming'
Object name: _naming_

Properties:

#### fqdn
* Data type: String
* Content: Fully qualified domain name of the EcoSystem
* Example: `"www.myEcoSystem.com"`
* Note: It is possible to set the wildcard value `"<<ip>>"` for this key.  In this case the setup uses the ip address of the EcoSystem at this point.

#### hostname
* Data type: String
* Content: Hostname of the EcoSystem
* Example: `"ces"`

#### domain
* Data type: String
* Content: Domain of the EcoSystem
* Example: `"ces.local"`

#### certificateType
* Data type: String
* Content: Certificate type for the connection to the EcoSystem
* Example: `"selfsigned"` or `"external"`

#### certificate
* Only necessary if *"certificateType"* is set to `"external"`
* Data type: String
* Content: The certificate of the EcoSystem in PEM format. If an intermediate certificate is used it also has to be entered here.

#### certificateKey
* Only necessary if *"certificateType"* is set to `"external"`
* Data type: String
* Content: The certificate key of the EcoSystem in PEM format

#### relayHost
* Data type: String
* Content: The mail relay host of the EcoSystem
* Example: `"mail.mydomain.com"`

#### mailAddress
* Optional
* Data type: String
* Content: The mail address used by all dogus to send mails (the 'From:'-Field)
* Example: `"mail@mydomain.com"`

#### useInternalIp
* Optional
* Data type: boolean
* Content: This switch enables the usage of a specific IP address for internal DNS resolution of the host. A value of `true` mandates a valid value in the field `internalIp`. If this field is not set it will be interpreted as `false` and ignored. 
* Example: `"useInternalIp": true`

#### internalIp
* Optional 
* Data type: String
* Content: This field contains the IP address that should be used for internal DNS resolution of the host. This is of special interest for installations that use a Split DNS configuration. In a Split DNS configuration the CES instance has a public IP address that is only reachable from the outside. Inside the CES instance a different, private IP address is used to interact with the internal parts of the instance. This field will be only evaluated if `userInternalIp` is set to `true`, otherwise it will be ignored.  
* Example: `"internalIp": "10.0.2.15"`

#### completed
* Data type: boolean
* Content: Logical value which shows if the *naming step* is completely finished
* Example: `true`


### Section 'UserBackend'
Object name: _userBackend_

Properties:

#### dsType
* Data type: String
* Content: User Backend type. If set to `"embedded"` the ldap dogu is automatically installed via the web interface (or has to be declared in the dogu step below) and can (optionally) be administrated using the User Management dogu later on. If set to `"external"` the login credentials for an external user backend have to be provided.

#### server
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: User backend server type
* `"activeDirectory"` or `"custom"`

#### attributeID
* Data type: String
* Content: Attribute name which describes the user ID in the user backend
* Has to be set to ``"uid"``, if _dsType_ is set to `"embedded"`
* Has to be set to ``"sAMAccountName"`` if *"dsType"*  is set to `"external"` and *"server"* is set to `"activeDirectory"`

#### attributeGivenName
* Only necessary if *"dsType"* ist set to `"external"` 
* Data type: String
* Content: Attribute name which describes the given name in the user backend
* Example: `"givenname"`

#### attributeSurname
* Only necessary if *"dsType"* ist set to `"external"` 
* Data type: String
* Content: Attribute name which describes the surname in the user backend
* Example: `"surname"`

#### attributeFullname
Data type: String

Content: Attribute name which describes the full name in the user backend

Has to be set to ``"cn"`` if *"dsType"* is set to `"embedded"` or *"server"* is set to `"activeDirectory"`

Example: `"fullname"`

#### attributeMail
* Data type: String
* Content: Attribute name which describes the e-mail in the user backend
* Has to be set to `"mail"` if *"dsType"* is set to `"embedded"` or *"server"* is set to `"activeDirectory"`
* Example: `"mail"`

#### attributeGroup
* Data type: String
* Content: Attribute name which describes the membership of a user in a group in the user backend
* Has to be set to `"memberOf"` if *"dsType"* is set to `"embedded"` or *"server"* is set to `"activeDirectory"`
* Example: `"memberOf"`

#### baseDN
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declaration of the Distinguished Name from which users are searched on the server
* Example: `"dc=mycomp1,dc=local"`

#### searchFilter
* Data type: String
* Content: Constraint that defines which object classes should be searched for
* Has to be set to `"(objectClass=person)"` if *"dsType"* is set to `"embedded"` or *"server"* is set to `"activeDirectory"`
* Example: `"(objectClass=person)"`

#### connectionDN
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declaration of the Distinguished Name of a user backend user with read access
* Example: `"username@mycompany.local"` or `"cn=username,dc=users,dc=mycomp,dc=local"`

#### password
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Password for the user set in *"connectionDN"*

#### host
* Data type: String
* Content: Address of the external user backend
* Has to be set to `"ldap"` if *"dsType"* is set to `"embedded"` 

#### port
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Port of the external user backend
* Has to be set to `"389"` if *"dsType"* is set to `"embedded"` 

#### encryption
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declares if the communication is encrypted
* Example: `"none"`, `"ssl"`, `"sslAny"`, `"startTLS"`, `"startTLSAny"`

#### groupBaseDN
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declaration of the Distinguished Name for the group mapping

#### groupSearchFilter
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declaration of search filters for the group mapping

#### groupAttributeName
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declaration of the group mapping name attribute

#### groupAttributeDescription
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declaration of the group mapping description attribute

#### groupAttributeMember
* Only necessary if *"dsType"* is set to `"external"` 
* Data type: String
* Content: Declaration of the group mapping member attribute

#### useUserConnectionToFetchAttributes

- Data type: boolean
- Content: Logical value that states if the logged on user shall be used for attribute queries from the user backend
- Has to be set to `true` if *"dsType"* was set to `embedded` or *"server"* was set to `"activeDirectory"`
- Example: `true`

#### completed
* Data type: boolean
* Content: Logical value which shows if the *"users step"* is completely finished
* Example: `true`


### Section 'dogus'
The information provided in this section of the setup.json will only be used in the setup process if the _completed_ property is set to 'true'. Otherwise, this step has to be handled manually via the web interface.

Object name: *dogus*

Properties:

#### defaultDogu
* Data type: String
* Content: Name of the dogu which will be initially opened when the EcoSystem is accessed with the browser
* Example: `"cockpit"`

#### install
* Data type: String array
* Content: List of all dogus to install. May include version information; if no version tag is set, the latest version is installed.
* Example: 

```[
[
    "official/cas",
    "official/cockpit",
    "official/nginx:1.13.11-7",
    "official/ldap:2.4.44-5",
    "official/postfix",
    "official/postgresql",
    "official/registrator",
    "official/usermgt:1.3.4-3"
]
```

#### completed
* Data type: boolean
* Content: Logical value which shows if the *dogu step* is completely finished
* Example: `true`


### Section 'admin'
The properties set here, except for *"adminGroup"*, are only relevant, if an "embedded" user backend is used. Otherwise the settings of the external user backend take effect.

Object name: _admin_

Properties:

#### mail
* Data type: String
* Content: E-mail address of the admin account
* Example: `"admin@mydomain.com"`

#### username
* Data type: String
* Content: Name of the admin account
* Example: `"admin"`

#### password
* Data type: String
* Content: Password of the admin account

#### adminGroup
* Data type: String
* Content: Name of the user backend group which will get administration rights in the EcoSystem
* This property has to be set even when an external user backend is used.
* Example: `"administrators"`

#### adminMember
* Data type: boolean
* Content: Logical value which shows if the created admin account will also become a member of the user backend group defined in *"adminGroup"*
* Example: `true`

#### completed
* Data type: boolean
* Content: Logical value which shows if the *admin step* is completely finished
* Example: `true`

### Section 'unixUser'

In this section, the credentials for the system administrator created within the setup process can be configured. If this step is skipped a user called *ces-admin* with a random generated password will be created and shown at the end of the setup process. This configuration of the system admin ist not possible via web interface.

Object name: _unixUser_

#### Name

- Data type: string
- Content: Name of the unix user
- Example: `"ces-admin"`

#### Password

- Data type: string
- Content: Password of the unix user
- Example: `"ces-password"`

## Extended Configuration Parameters

#### sequentialDoguStart (optional)

Is this boolean value set to 'true', the start of the dogus at the end of the setup will be sequential instead of parallel. The setup will wait for a starting dogu to reach its *healthy* state before starting the next one.

Object name: *sequentialDoguStart*

#### extendedConfiguration (optional)

This section holds additional configuration for the ces-setup.

##### ignoreCriticalHealthCheck (optional)
* Data type: boolean
* Content: If this is set to `true`, health check errors during dogu startup at the end of the setup are logged, but the setup does not fail.
* Example: `{ "ignoreCriticalHealthCheck": true }`

#### registryConfig (optional)
Here you can define values which will be written directly to the registry. This is not possible via the web interface, only via the setup.json file. The values defined here will be written at ``/config/`` into the registry (*etcd*) of the EcoSystem.

Object name: *registryConfig*

The following objects are examples:

##### \_global
* Content: Global configuration data
* Example: `{
  "stage":"development",
  "manager_group": "cesManager"
  }` or `{
  "stage":"production"
  }`

##### containers/additional_hosts
- Content: Host-Entries for all dogus
- Example:
```
"registryConfig": {
  "_global": {
    "containers":{
      "additional_hosts":{
        "host1": "123.123.123.123",
        "host2": "123.123.123.123"
      }
    }
  }
}
```

Hostnames must not occur multiple times.
It is also not possible to add the same hostnames as in global configuration in the cesapp configuration.


##### backup

- Content: Configuration of the backup and restore mechanisms of the EcoSystem
- Example: 

```{
{
  "registryConfig": {
    "backup": {
      "active": "true",
      "time": "{\"Times\":[\"12:30:00\"]}",
      "encryption_key": "secret_123",
      "backup_type": "SFTP",
      "sftp_config": {
        "address": "sftp:root@192.168.56.1:/root/repo"
      },
      "retention_enabled": "true",
      "retention_strategy": "removeAllButKeepLatest",
      "metrics_token": "metrics_123",
      "rest_token": "rest_123",
      "admin_role": "backupAdmins",
      "deny_cross_blueprint_restores" : "false"
    }
  }
}
```

- Key: `"deny_cross_blueprint_restores"`
  
  When set to `true`, backups are bound to a blueprintId. After a blueprint-Upgrade the backups cannot be restored.
  When not set or set to `false`, any backup can be restored.
  
- Key: `"pre_backup_script"`
  
  This key can be set to a path to a bash script.
  The path cannot be empty. The path has to be an absolute path. The script must exist and must be executable.
  The script is automatically executed before each backup.
  
- Key: `"post_backup_script"`
  
  This key can be set to a path to a bash script.
  The path cannot be empty. The path has to be an absolute path. The script must exist and must be executable.
  The script is automatically executed after each successful backup.
  
- Key: `"pre_restore_script"`
  
  This key can be set to a path to a bash script.
  The path cannot be empty. The path has to be an absolute path. The script must exist and must be executable.
  The script is automatically executed before each restore.
  
- Key: `"post_restore_script"`
  
  This key can be set to a path to a bash script.
  The path cannot be empty. The path has to be an absolute path. The script must exist and must be executable.
  The script is automatically executed after each successful restore.

##### cas

- Key: ` "limit/max_number"`

  Specifies the maximum amount of login failures per user account. The account will be disabled for a limited time if this number of attempts is exceeded during the given failure store time (see below).

  If the Key's value is set to `0`, this functionality will be deactivated and no limitation is implemented. If it is set to a value greater than `0`, all other attributes of cas have to be set to appropriate values.

- Key: `"limit/failure_store_time"`

  Specifies the time duration since the last login failure where all failed login attempts are saved. If this time passes by between two login attempts the amount of all saved login failures is resetted.

- Key: `"limit/lock_time"`

  Specifies the account lock time if the maximum number of login failures has been reached. During this time period no login is possible. This key's value is taken as seconds and has to be greater than `0` if this functionality is activated.

- Key: `"forgot_password_text"`

  Specifies the content of the text message that shows up when clicking on 'Forgot password?' inside the logon screen.

- Key: `"legal_urls/terms_of_service"`

   Specifies the terms of service URL to be shown on the CAS login/logout screen. If this key is null or does not exist the corresponding link "Terms of Service" will not be shown. The changes are effective after a restart of the CAS Dogu. 
 
- Key: `"legal_urls/imprint"`
   
   Specifies the imprint URL to be shown on the CAS login/logout screen. If this key is null or does not exist the corresponding link "Imprint" will not be shown. The changes are effective after a restart of the CAS Dogu. 

- Key: `"legal_urls/privacy_policy"`
   
   Specifies the privacy policy URL to be shown on the CAS login/logout screen. If this key is null or does not exist the corresponding link "Privacy Policy" will not be shown. The changes are effective after a restart of the CAS Dogu. 

- Key: `"session_tgt/max_time_to_live_in_seconds"`

   Maximum session timeout - TGT will expire after defined timespan regardless the usage

- Key: `"session_tgt/time_to_kill_in_seconds"`

   Idle session timeout -  TGT will expire sooner if no further requests keep the session alive


##### cockpit

- Content: Configuration of the welcome dashboard of the cloudogu EcoSystem
- Example:

```
{
  "welcomeDashboard" :
  "{
    \"title\": \"Custom Welcome Dashboard\",
    \"structure\": \"12/4-4-4\",
    \"rows\":
    [
    {
      \"columns\":
      [
      {
        \"styleClass\": \"col-md-12\",
        \"widgets\": [ ],
        \"cid\": \"1495540024138-67\"
      }
      ]
      },
      {
        \"columns\":
        [
        {
          \"styleClass\": \"col-md-4\",
          \"widgets\":
          [
          {
            \"type\": \"clock\",
            \"config\":
            {
              \"timePattern\": \"HH:mm:ss\",
              \"datePattern\": \"YYYY-MM-DD\"
              },
              \"title\": \"Clock\",
              \"titleTemplateUrl\": \"../src/templates/widget-title.html\",
              \"editTemplateUrl\": \"../src/templates/widget-edit.html\",
              \"wid\": \"1495540110609-91\"
              },
              {
                \"type\": \"linklist\",
                \"config\": { \"links\":
                [
                {
                  \"title\": \"Custom Link\",
                  \"href\": \"https://custom.com\"
                }
                ]
                },
                \"title\": \"Links\",
                \"titleTemplateUrl\": \"../src/templates/widget-title.html\",
                \"editTemplateUrl\": \"../src/templates/widget-edit.html\",
                \"wid\": \"1495526407267-47\"
              }
              ],
              \"cid\": \"1495540024149-69\"
            }
            ]
          }
          ],
          \"titleTemplateUrl\": \"app/dashboard/partials/custom-dashboard-title.html\"
  }"
}
```

- Note: If this definition is not set at all or if this definition is not in a correct JSON state, the default dashboard is shown.
- Note: The maximum possible size of a JSON dashboard description is 2 MB.

##### jenkins

* Key `updateSiteUrl`: Information about the jenkins update site URLs
* Key `additional.plugins`: Contains a comma separated list with plugin names that are installed on startup
* Example:

```
{
  "updateSiteUrl": {
    "url1":"jenkinsUpdateSiteURL1",
    "url2":"jenkinsUpdateSiteURL2"
  }
  "additional.plugins": "docker-plugin,docker-workflow"
}
```

##### nexus
* Content: Option to deactivate default docker registry creation
* Example:`{
    "installDefaultDockerRegistry": "false"
}`

* Content: Option to enable repository sandboxing
* Example:`{
    "nexus.repository.sandbox.enable": "true"
}`

* Content: Option to disable the outreach management capability/ welcome page
* Example:`{
    "disableOutreachManagement": "true"
}`

* Content: Options to import HTTP/HTTPS proxy settings and excluded hosts
* Example:
````
"proxyConfiguration": {
        "http": {
          "host": "testHTTPhost",
          "port": "1234",
          "authentication": {
            "username": "testHTTPuser",
            "password": "testHTTPpassword",
            "ntlmHost": "ntlm HTTPhostname",
            "domain": "ntlm HTTPdomain"
          }
        },
        "https": {
          "host": "testHTTPShost",
          "port": "4321",
          "authentication": {
            "username": "testHTTPSuser",
            "password": "testHTTPSpassword",
            "ntlmHost": "ntlm HTTPShostname",
            "domain": "ntlm HTTPSdomain"
          }
        },
        "nonProxyHosts": "nonhost1,nonhost2,nonhost123456nope.nopetown"
      }
````

##### nginx/externals

- Content: configuration of external links inside the warp menue
- Beispiel:

```
{
  "cloudogu": "{
    \"DisplayName\": \"Cloudogu\",
    \"Description\": \"Beschreibungstext für Cloudogu Webseite\",
    \"Category\": \"External Links\",
    \"URL\": \"https://www.cloudogu.com/\"
  }"
}
```

##### nexus/claim

- Data type: string, HCL/JSON format
- Content: Configuration of sonatype nexus repositories
- Note: This configuration set can be triggered 'once' or 'always' when the nexus dogu starts. The exact definition of the nexus properties can be found in the official nexus documentation
- Further information: https://github.com/cloudogu/nexus-claim
- [Nexus 2 example \[Link\]](https://github.com/cloudogu/nexus-claim/blob/develop/resources/nexus2/nexus-initial-example.hcl)
- [Nexus 3 example \[Link\]](https://github.com/cloudogu/nexus-claim/blob/develop/resources/nexus3/nexus_custom.hcl)
- _state: Repositories will be added, edited or deleted depending on which state is set. If the state is set to `"absent"` a potentially existing repository with the given ID will be deleted. If the state is set to `"present"` and the defined repository is non-existing it will be created. If it exists, its properties like name will be edited.

##### postfix

- Content: Configuration of the TLS encryption of the postfix smtp client
- For further information see [official postfix documentation](http://www.postfix.org/documentation.html)
- Example usage inside setup.json:

```
"registryConfig":{
	"postfix" : {
		"smtp_tls_security_level": "encrypt",
		"smtp_tls_CAfile": "<CERTIFICATE>",
		"smtp_tls_exclude_ciphers": "...",
		"smtp_tls_loglevel": "...",
		"smtp_tls_mandatory_ciphers": "...",
		"smtp_tls_mandatory_protocols": "..."
	}
}
```

##### sonar

- Content: Set custom SonarQube UpdateCenter URL and a list of default plugins here
- Example:
````
{
  "sonar.updatecenter.url": "http://customupdatecenter.com",
  "sonar.plugins.default": "pmd,jacoco"
}
````

##### jira
* Content: Define a user group from the CES which should get the application role `JIRA SOFTWARE`.
* Example:
```
{
    "jira_software_users_group": "my-group-name"
}
```
* Content: Define the interval in seconds to synchronize the LDAP user directory cache. [Default: 3600]
* Example:
```
{
    "ldap/sync_interval": "600"
}
```

#### registryConfigEncrypted (optional)
Here you can define values which will be written encrypted to the registry (etcd). This is not possible via the web interface, only via the setup.json file. The values defined here will be written at ``/config/`` into the registry.
In the first level only Dogus which will be installed during the setup are possible. For other entries there is no key for encryption.

Object name: _registryConfigEncrypted_

Can consist the following objects:

##### postfix
* Content: Postfix SMTP client RSA certificate in PEM format
* Example: `{
    "smtp_tls_cert_file": "<CERTIFICATE>"
    }`
* Content: Postfix SMTP client RSA private key in PEM format
* Example: `{
    "smtp_tls_key_file": "<PRIVATE KEY>"
    }`
* Example usage inside setup.json:

```
"registryConfigEncrypted":{
	"postfix" : {
		"smtp_tls_cert_file": "<CERTIFICATE>",
		"smtp_tls_key_file": "<PRIVATE KEY>"
	}
}
```

##### swaggerui

```
  "registryConfig": {
    "swaggerui": {
      "validator_url": "https://validator.swagger.io/validator"
    }
  }
```

- Key: `"validator_url"`
  
  This is the url to the SwaggerValidator. Set this to `https://validator.swagger.io/validator` to use the default
  SwaggerValidator. Do not set the key or set it to an empty string if you want to disable the SwaggerValidator.
