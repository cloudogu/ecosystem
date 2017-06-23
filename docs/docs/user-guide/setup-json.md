## Automating the Cloudogu Ecosystem setup process
The setup mechanism of the Cloudogu Ecosystem can be performed in different ways. One way is to provide all necessary data and set all options via the web interface. Another way is to create a file called **setup.json** which contains some or all configuration data needed. This file has to be placed into the ``/vagrant`` or ``/etc/ces`` folder and needs to be formatted in JSON. All data defined in it will be automatically inserted into the corresponding setup web interface fields. If the entire configuration of the setup is present, the setup can be done fully automatically by setting all _completed_-values to true (see below).

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
* Content: Logical value whcich shows if the _region_ step is completely finished
* Example: ``true``


#### Naming-Schritt
Objektname: _naming_

Properties:

##### fqdn
* Data type: String
* Content: Vollständige Domain des Ecosystems
* Example: ``"www.myecosystem.com"``

##### hostname
* Data type: String
* Content: Hostname des Ecosystems
* Example: ``"ces"``

##### domain
* Data type: String
* Content: Domain des Ecosystems
* Example: ``"ces.local"``

##### certificateType
* Data type: String
* Content: Art des Zertifikats für die Verbindung zum Ecosystem
* ``"selfsigned"`` or ``"external"``

##### certificate
* Nur notwendig, wenn certificateType auf "external" gesetzt wurde
* Data type: String
* Content: Das Zertifikat für das Ecosystem im PEM-Format. Sollte ein Intermediate-Zertifikat eingesetzt werden, muss auch dieses hier eingetragen werden.

##### certificateKey
* Nur notwendig, wenn certificateType auf "external" gesetzt wurde
* Data type: String
* Content: Der Zertifikatsschlüssel für das Ecosystem im PEM-Format

##### relayHost
* Data type: String
* Content: Der Mail Relay Host für das Ecosystem über den der Mailversand abgewickelt werden soll
* Example: ``"mail.mydomain.com"``

##### completed
* Data type: boolean
* Content: Logical value whcich shows if the _naming_ step is completely finished
* Example: ``true``


#### Users-Schritt
Objektname: _userBackend_

Properties:

##### dsType
* Data type: String
* Content: Typ des User Backends. Bei Benutzung von ``"embedded"`` wird ein ldap-Dogu installiert, welches sich dann (optional) mithilfe des User Management-Dogus verwalten lässt. Bei Benutzung von ``"external"`` sind die Zugangsdaten für ein externes User Backend zu übergeben.

##### server
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Typ des User Backend Servers
* ``"activeDirectory"`` or ``"custom"``

##### attributeID
* Data type: String
* Content: Attributname, der im User Backend die User ID beschreibt
* Muss auf ``"uid"`` gesetzt werden, wenn dsType auf "embedded" gesetzt wurde
* Muss auf ``"sAMAccountName"`` gesetzt werden, wenn _dsType_ auf "external" und _server_ auf "activeDirectory" gesetzt wurde

##### attributeGivenName
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Attributname, der im User Backend den Vornamen beschreibt
* Example: ``"givenname"``

##### attributeSurname
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Attributname, der im User Backend den Nachnamen beschreibt
* Example: ``"surname"``

##### attributeFullname
* Data type: String
* Content: Attributname, der im User Backend den vollen Namen beschreibt
* Muss auf ``"cn"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Example: ``"fullname"``

##### attributeMail
* Data type: String
* Content: Attributname, der im User Backend das E-Mail-Attribut beschreibt
* Muss auf ``"mail"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Example: ``"mail"``

##### attributeGroup
* Data type: String
* Content: Attributname, mit dem im User Backend die Zugehörigkeit eines Users zu einer Gruppe geregelt wird
* Muss auf ``"memberOf"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Example: ``"memberOf"``

##### baseDN
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Angabe des Distinguished Name von der aus auf dem Server nach Benutzern gesucht wird
* Example: ``"dc=mycomp1,dc=local"``

##### searchFilter
* Data type: String
* Content: Einschränkung, nach welchen Objektklassen gesucht werden soll
* Muss auf ``"(objectClass=person)"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Example: ``"(objectClass=person)"``

##### connectionDN
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Angabe des Distinguished Name eines leseberechtigten Benutzers im User Backend
* Example: ``"username@mycompany.local"`` or ``"cn=username,dc=users,dc=mycomp,dc=local"``

##### password
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Angabe des Passworts des unter _connectionDN_ gesetzten Nutzers

##### host
* Data type: String
* Content: Adresse des externen User Backends
* Muss auf ``"ldap"`` gesetzt werden, wenn dsType auf "embedded" gesetzt wurde

##### port
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Port, über den das externe User Backend erreicht werden kann
* Muss auf ``"389"`` gesetzt werden, wenn dsType auf "embedded" gesetzt wurde

##### encryption
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Einstellung ob und ggf. welche Verschlüsselung genutzt werden soll
* Example: ``"none"``, ``"ssl"``, ``"sslAny"``, ``"startTLS"``, ``"startTLSAny"``

##### groupBaseDN
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Angabe des Distinguished Name für das Group Mapping

##### groupSearchFilter
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Angabe von Suchfiltern für das Group Mapping

##### groupAttributeName
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Data type: String
* Content: Angabe des Attributs für das Group Mapping

##### completed
* Data type: boolean
* Content: Logical value whcich shows if the _users_ step is completely finished
* Example: ``true``

##### useUserConnectionToFetchAttributes
* Data type: boolean
* Content: Wahrheitswert, ob der jeweils angemeldete Nutzer zur Abfrage der Attribute aus dem User Backend genutzt werden soll
* Muss auf ``true`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Example: ``true``


#### Dogu-Schritt
Objektname: _dogus_

Die Daten, die in diesem Schritt über die setup.json eingegeben werden, werden im Setupprozess nur übernommen, wenn die _completed_-Eigenschaft auf 'true' gesetzt ist. Anderenfalls ist der Schritt manuell über die Weboberfläche auszufüllen.

Properties:

##### defaultDogu
* Data type: String
* Content: Name des Dogus, welches beim Aufruf des Ecosystems im Browser standardmäßig angesteuert wird
* Example: ``"cockpit"``

##### install
* Data type: String array
* Content: Liste aller Dogus, die installiert werden sollen
* Example: ``[
      "official/cas",
      "official/cockpit",
      "official/nginx",
      "official/ldap",
      "official/postfix",
      "official/postgresql",
      "official/registrator",
      "official/usermgt"
    ]``

##### completed
* Data type: boolean
* Content: Logical value whcich shows if the _dogu_ step is completely finished
* Example: ``true``


#### Admin-Schritt
Diese Einstellungen sind, bis auf _adminGroup_, nur relevant, sofern ein "embedded" User Backend gewählt wurde. Anderenfalls sind die Vorgaben des externen User Backends gültig.
Objektname: _admin_

Properties:

##### mail
* Data type: String
* Content: E-Mail-Adresse des Admin-Kontos
* Example: ``"admin@mydomain.com"``

##### username
* Data type: String
* Content: Name des Admin-Kontos
* Example: ``"admin"``

##### password
* Data type: String
* Content: Passwort des Admin-Kontos

##### confirmPassword
* Data type: String
* Content: Erneute Eingabe des Passworts des Admin-Kontos zur Bestätigung

##### adminGroup
* Data type: String
* Content: Name der Gruppe im User Backend, die Administratorrechte im Ecosystem erhalten soll
* Diese Einstellung ist auch zu setzen, wenn ein externes User Backend gewählt wurde
* Example: ``"administrators"``

##### adminMember
* Data type: boolean
* Content: Wahrheitswert, ob das angelegte Admin-Konto auch Mitglied der unter _adminGroup_ definierten Gruppe im User Backend werden soll
* Example: true

##### completed
* Data type: boolean
* Content: Logical value whcich shows if the _admin_ step is completely finished
* Example: ``true``


#### registryConfig (optional)
An dieser Stelle lassen sich Werte definieren, die direkt in die Registry übernommen werden sollen. Hierfür gibt es keinen äquivalenten Schritt in der Setupoberfläche. Die hier definierten Werte werden unter ``/config/`` in der Registry des Ecosystems abgelegt.

Objektname: _registryConfig_

Enthält beispielsweise folgende Objekte:

##### \_global
* Content: Globale Konfigurationsdaten
* Example: ``{
"stage":"development"
}`` or ``{
"stage":"production"
}``

##### jenkins
* Content: Informationen über die Update-Site-URLs für Jenkins
* Example:``{
  "updateSiteUrl": {
"url1":"jenkinsUpdateSiteURL1",
"url2":"jenkinsUpdateSiteURL2"
}
}``
