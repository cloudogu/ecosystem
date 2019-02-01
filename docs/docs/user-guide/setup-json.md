## Automating the Cloudogu EcoSystem Setup Process
The setup mechanism of the Cloudogu EcoSystem can be performed in different ways. One way is to provide all necessary data and set all options via the web interface. Another way is to create a file called **setup.json** which contains some or all configuration data needed. This file has to be placed into the ``/vagrant`` or ``/etc/ces`` folder and needs to be formatted in JSON. All data defined in it will be automatically inserted into the corresponding setup web interface fields. If the entire configuration of the setup is present, the setup can be done fully automatically by setting all _completed_-values to true (see below).

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

### Setup steps
The setup.json file consists of objects named after the corresponding setup step (e.g. 'region' or 'admin'). These objects contain properties describing the configuration of this setup step. If the _completed_ property is set to ``true``, all properties of the setup.json for this step are accepted and the step will not show up in the web interface.

#### Region step
Object name: _region_

Properties:

##### locale
* Data type: String
* Content: locale settings of the Ecosystem
* Example: ``"en_US.utf8"``


##### timeZone
* Data type: String
* Content: Timezone of the Ecosystem
* Example: ``"Europe/Berlin"``

##### completed
* Data type: boolean
* Content: Logical value which shows if the _region_ step is completely finished
* Example: ``true``


#### Naming step
Object name: _naming_

Properties:

##### fqdn
* Data type: String
* Content: Fully qualified domain name of the Ecosystem
* Example: ``"www.myecosystem.com"``

##### hostname
* Data type: String
* Content: Hostname of the Ecosystem
* Example: ``"ces"``

##### domain
* Data type: String
* Content: Domain of the Ecosystem
* Example: ``"ces.local"``

##### certificateType
* Data type: String
* Content: Certificate type for the connection to the Ecosystem
* ``"selfsigned"`` or ``"external"``

##### certificate
* Only necessary, if certificateType is set to "external"
* Data type: String
* Content: The certificate of the Ecosystem in PEM format. If an intermediate certificate is used it also has to be entered here

##### certificateKey
* Only necessary, if certificateType is set to "external"
* Data type: String
* Content: The certificate key of the Ecosystem in PEM format

##### relayHost
* Data type: String
* Content: The mail relay host of the Ecosystem
* Example: ``"mail.mydomain.com"``

##### mailAddress
* Optional
* Data type: String
* Content: The mail address used by all dogus to send mails (the 'From:'-Field)
* Example: ``"mail@mydomain.com"``

##### completed
* Data type: boolean
* Content: Logical value which shows if the _naming_ step is completely finished
* Example: ``true``


#### Users step
Object name: _userBackend_

Properties:

##### dsType
* Data type: String
* Content: User Backend type. If set to ``"embedded"`` the ldap dogu is automatically installed via the web interface (or has to be declared in the dogu step below) and can (optionally) be administrated using the User Management dogu later on. If set to ``"external"`` the login credentials for an external user backend have to be provided.

##### server
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: User backend server type
* ``"activeDirectory"`` or ``"custom"``

##### attributeID
* Data type: String
* Content: Attribute name which describes the user ID in the user backend
* Has to be set to ``"uid"``, if _dsType_ is set to "embedded"
* Has to be set to ``"sAMAccountName"``, if _dsType_  is set to "external" and _server_  is set to "activeDirectory"

##### attributeGivenName
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Attribute name which describes the given name in the user backend
* Example: ``"givenname"``

##### attributeSurname
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Attribute name which describes the surname in the user backend
* Example: ``"surname"``

##### attributeFullname
* Data type: String
* Content: Attribute name which describes the full name in the user backend
* Has to be set to ``"cn"``, if _dsType_ is set to "embedded" or _server_ is set to "activeDirectory"
* Example: ``"fullname"``

##### attributeMail
* Data type: String
* Content: Attribute name which describes the e-mail in the user backend
* Has to be set to ``"mail"``, if _dsType_ is set to "embedded" or _server_ is set to "activeDirectory"
* Example: ``"mail"``

##### attributeGroup
* Data type: String
* Content: Attribute name which describes the membership of a user in a group in the user backend
* Has to be set to ``"memberOf"``, if _dsType_ is set to "embedded" or _server_ is set to "activeDirectory"
* Example: ``"memberOf"``

##### baseDN
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Declaration of the Distinguished Name from which users are searched on the server
* Example: ``"dc=mycomp1,dc=local"``

##### searchFilter
* Data type: String
* Content: Constraint, which object classes should be searched for
* Has to be set to ``"(objectClass=person)"``, if _dsType_ is set to "embedded" or _server_ is set to  "activeDirectory"
* Example: ``"(objectClass=person)"``

##### connectionDN
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Declaration of the Distinguished Name of a user backend user with read access
* Example: ``"username@mycompany.local"`` or ``"cn=username,dc=users,dc=mycomp,dc=local"``

##### password
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Password for the user set in _connectionDN_

##### host
* Data type: String
* Content: Address of the external user backend
* Has to be set to ``"ldap"``, if _dsType_ is set to "embedded"

##### port
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Port of the external user backend
* Has to be set to ``"389"``, if _dsType_ is set to "embedded"

##### encryption
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Declares if the communication is encrypted
* Example: ``"none"``, ``"ssl"``, ``"sslAny"``, ``"startTLS"``, ``"startTLSAny"``

##### groupBaseDN
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Declaration of the Distinguished Name for the group mapping

##### groupSearchFilter
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Declaration of search filters for the group mapping

##### groupAttributeName
* Only necessary, if _dsType_ is set to "external"
* Data type: String
* Content: Declaration of the group mapping name attribute

##### completed
* Data type: boolean
* Content: Logical value which shows if the _users_ step is completely finished
* Example: ``true``

##### useUserConnectionToFetchAttributes
* Data type: boolean
* Content: Logical value which shows if the user connection of the user which is signed in at the time the attributes are fetched should be used to fetch the attributes from the user backend
* Has to be set to ``true``, if _dsType_ is set to "embedded" or _server_ is set to "activeDirectory"
* Example: ``true``


#### Dogu step
Object name: _dogus_

The information provided in this section of the setup.json will only be used in the setup process if the _completed_ property is set to 'true'. Otherwise, this step has to be handled manually via the web interface.

Properties:

##### defaultDogu
* Data type: String
* Content: Name of the dogu which will be initially opened when the Ecosystem is accessed with the browser
* Example: ``"cockpit"``

##### install
* Data type: String array
* Content: List of all dogus to install. May include version information; if no version tag is set, the latest version is installed.
* Example: ``[
      "official/cas",
      "official/cockpit",
      "official/nginx:1.13.11-7",
      "official/ldap:2.4.44-5",
      "official/postfix",
      "official/postgresql",
      "official/registrator",
      "official/usermgt:1.3.4-3"
    ]``

##### completed
* Data type: boolean
* Content: Logical value which shows if the _dogu_ step is completely finished
* Example: ``true``


#### Admin step
The properties set here, except for _adminGroup_, are only relevant, if an "embedded" user backend is used. Otherwise the settings of the external user backend take effect.

Object name: _admin_

Properties:

##### mail
* Data type: String
* Content: E-mail address of the admin account
* Example: ``"admin@mydomain.com"``

##### username
* Data type: String
* Content: Name of the admin account
* Example: ``"admin"``

##### password
* Data type: String
* Content: Password of the admin account

##### confirmPassword
* Data type: String
* Content: Password of the admin account again, for confirmation

##### adminGroup
* Data type: String
* Content: Name of the user backend group which will get administration rights in the Ecosystem
* This property has to be set even when an external user backend is used.
* Example: ``"administrators"``

##### adminMember
* Data type: boolean
* Content: Logical value which shows if the created admin account will also become a member of the user backend group defined in _adminGroup_
* Example: ``true``

##### completed
* Data type: boolean
* Content: Logical value which shows if the _admin_ step is completely finished
* Example: ``true``

#### sequentialDoguStart (optional)

Is this boolean value set to 'true', the start of the dogus at the end of the setup will be sequential instead of parallel. The setup will wait for a starting dogu to reach its 'healthy' state before starting the next one.

#### registryConfig (optional)
Here you can define values which will be written directly to the registry (=etcd, at the moment). This is not possible via the web interface, only via the setup.json file. The values defined here will be written at ``/config/`` into the registry.

Object name: _registryConfig_

The following objects are examples:

##### \_global
* Content: Global configuration data
* Example: ``{
"stage":"development",
"manager_group": "cesManager"
}`` or ``{
"stage":"production"
}``

##### jenkins
* Content: Information about the jenkins update site URLs
* Example:``{
  "updateSiteUrl": {
"url1":"jenkinsUpdateSiteURL1",
"url2":"jenkinsUpdateSiteURL2"
}
}``

##### postfix
* Content: Set smtp_tls_security_level parameter here
* Example:``{
    "smtp_tls_security_level": "encrypt"
}``

##### nexus
* Content: Option to deactivate default docker registry creation
* Example:``{
    "installDefaultDockerRegistry": "false"
}``

* Content: Option to enable repository sandboxing
* Example:``{
    "nexus.repository.sandbox.enable": "true"
}``

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

##### cockpit
* Content: Set configuration of welcome-dashboard here
* Example:``{
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
}``
* Note: If this is not set or not in correct JSON format, the default dashboard will be displayed.
* Note: The size of the JSON-definition of the dashboard must not exceed 2MB.

##### external warp-menu entries
* Content: External Links
* Example:
````
"nginx": {
      "externals": {
        "golem": "{\"DisplayName\": \"Golem\",\"Description\": \"Description\",\"Category\": \"External Links\",\"URL\": \"https://www.golem.de/\"}"
      }
    }
````
#### registryConfigEncrypted (optional)
Here you can define values which will be written encrypted to the registry (=etcd, at the moment). This is not possible via the web interface, only via the setup.json file. The values defined here will be written at ``/config/`` into the registry.
In the first level only Dogus which will be installed during the setup are possible. For other entries there is no key for encryption.

Object name: _registryConfigEncrypted_

The following objects are examples:

##### postfix
* Set content of the smtp_tls_key_file here.
* Example:``{
    "smtp_tls_key_file": "<Certificate>"
}``

