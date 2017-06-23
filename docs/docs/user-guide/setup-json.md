## Automatisierung des Cloudogu Ecosystem Setupprozesses
Der Setupmechanismus des Cloudogu Ecosystems lässt sich auf verschiedene Arten ausführen. Ein Weg führt über die Oberfläche im Browser, in der man alle relevanten Daten eingeben und Optionen auswählen kann. Des weiteren kann man mithilfe einer **setup.json** benannten Konfigurationsdatei die Felder im Setup vorbefüllen. Diese Datei muss im Ordner ``/vagrant`` oder ``/etc/ces`` liegen und nach dem JSON-Standard formatiert sein. Alle Daten, die in dieser Datei definiert werden, werden automatisch im Setupprozess in die entsprechenden Felder eingetragen. Sind alle Daten und Einstellungen für das Setup im Voraus klar, kann man das Setup auch komplett automatisch ablaufen lassen. Dafür ist für jeden Schritt die Eigenschaft _completed_ zu setzen (siehe unten).

Beispiel:
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

### Setupschritte
Der Inhalt der setup.json besteht aus Objekten, die den Titel des jeweiligen Setupschritts (bspw. 'region' oder 'admin') tragen. Diese Objekte beinhalten Eigenschaften, welche die Werte beschreiben, die dem jeweiligen Setupschritt übergeben werden sollen. Ist die _completed_-Eigenschaft auf ``true`` gesetzt, werden die Eigenschaften übernommen und der Schritt im Setupvorgang nicht mehr angezeigt.

#### Region-Schritt
Objektname: _region_

Eigenschaften:

##### locale
* Datentyp: String
* Inhalt: locale-Einstellung des Ecosystems
* Beispiel: ``"en_US.utf8"``


##### timeZone
* Datentyp: String
* Inhalt: Zeitzone des Ecosystems
* Beispiel: ``"Europe/Berlin"``

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Region-Schritt komplett ist
* Beispiel: ``true``


#### Naming-Schritt
Objektname: _naming_

Eigenschaften:

##### fqdn
* Datentyp: String
* Inhalt: Vollständige Domain des Ecosystems
* Beispiel: ``"www.myecosystem.com"``

##### hostname
* Datentyp: String
* Inhalt: Hostname des Ecosystems
* Beispiel: ``"ces"``

##### domain
* Datentyp: String
* Inhalt: Domain des Ecosystems
* Beispiel: ``"ces.local"``

##### certificateType
* Datentyp: String
* Inhalt: Art des Zertifikats für die Verbindung zum Ecosystem
* ``"selfsigned"`` oder ``"external"``

##### certificate
* Nur notwendig, wenn certificateType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Das Zertifikat für das Ecosystem im PEM-Format. Sollte ein Intermediate-Zertifikat eingesetzt werden, muss auch dieses hier eingetragen werden.

##### certificateKey
* Nur notwendig, wenn certificateType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Der Zertifikatsschlüssel für das Ecosystem im PEM-Format

##### relayHost
* Datentyp: String
* Inhalt: Der Mail Relay Host für das Ecosystem über den der Mailversand abgewickelt werden soll
* Beispiel: ``"mail.mydomain.com"``

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Naming-Schritt komplett ist
* Beispiel: ``true``


#### Users-Schritt
Objektname: _userBackend_

Eigenschaften:

##### dsType
* Datentyp: String
* Inhalt: Typ des User Backends. Bei Benutzung von ``"embedded"`` wird ein ldap-Dogu installiert, welches sich dann (optional) mithilfe des User Management-Dogus verwalten lässt. Bei Benutzung von ``"external"`` sind die Zugangsdaten für ein externes User Backend zu übergeben.

##### server
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Typ des User Backend Servers
* ``"activeDirectory"`` oder ``"custom"``

##### attributeID
* Datentyp: String
* Inhalt: Attributname, der im User Backend die User ID beschreibt
* Muss auf ``"uid"`` gesetzt werden, wenn dsType auf "embedded" gesetzt wurde
* Muss auf ``"sAMAccountName"`` gesetzt werden, wenn _dsType_ auf "external" und _server_ auf "activeDirectory" gesetzt wurde

##### attributeGivenName
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Attributname, der im User Backend den Vornamen beschreibt
* Beispiel: ``"givenname"``

##### attributeSurname
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Attributname, der im User Backend den Nachnamen beschreibt
* Beispiel: ``"surname"``

##### attributeFullname
* Datentyp: String
* Inhalt: Attributname, der im User Backend den vollen Namen beschreibt
* Muss auf ``"cn"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Beispiel: ``"fullname"``

##### attributeMail
* Datentyp: String
* Inhalt: Attributname, der im User Backend das E-Mail-Attribut beschreibt
* Muss auf ``"mail"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Beispiel: ``"mail"``

##### attributeGroup
* Datentyp: String
* Inhalt: Attributname, mit dem im User Backend die Zugehörigkeit eines Users zu einer Gruppe geregelt wird
* Muss auf ``"memberOf"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Beispiel: ``"memberOf"``

##### baseDN
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Distinguished Name von der aus auf dem Server nach Benutzern gesucht wird
* beispiel: ``"dc=mycomp1,dc=local"``

##### searchFilter
* Datentyp: String
* Inhalt: Einschränkung, nach welchen Objektklassen gesucht werden soll
* Muss auf ``"(objectClass=person)"`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Beispiel: ``"(objectClass=person)"``

##### connectionDN
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Distinguished Name eines leseberechtigten Benutzers im User Backend
* Beispiel: ``"username@mycompany.local"`` oder ``"cn=username,dc=users,dc=mycomp,dc=local"``

##### password
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Passworts des unter _connectionDN_ gesetzten Nutzers

##### host
* Datentyp: String
* Inhalt: Adresse des externen User Backends
* Muss auf ``"ldap"`` gesetzt werden, wenn dsType auf "embedded" gesetzt wurde

##### port
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Port, über den das externe User Backend erreicht werden kann
* Muss auf ``"389"`` gesetzt werden, wenn dsType auf "embedded" gesetzt wurde

##### encryption
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Einstellung ob und ggf. welche Verschlüsselung genutzt werden soll
* Beispiel: ``"none"``, ``"ssl"``, ``"sslAny"``, ``"startTLS"``, ``"startTLSAny"``

##### groupBaseDN
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Distinguished Name für das Group Mapping

##### groupSearchFilter
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Angabe von Suchfiltern für das Group Mapping

##### groupAttributeName
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Attributs für das Group Mapping

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Users-Schritt komplett ist
* Beispiel: ``true``

##### useUserConnectionToFetchAttributes
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der jeweils angemeldete Nutzer zur Abfrage der Attribute aus dem User Backend genutzt werden soll
* Muss auf ``true`` gesetzt werden, wenn dsType auf "embedded" oder _server_ auf "activeDirectory" gesetzt wurde
* Beispiel: ``true``


#### Dogu-Schritt
Objektname: _dogus_

Die Daten, die in diesem Schritt über die setup.json eingegeben werden, werden im Setupprozess nur übernommen, wenn die _completed_-Eigenschaft auf 'true' gesetzt ist. Anderenfalls ist der Schritt manuell über die Weboberfläche auszufüllen.

Eigenschaften:

##### defaultDogu
* Datentyp: String
* Inhalt: Name des Dogus, welches beim Aufruf des Ecosystems im Browser standardmäßig angesteuert wird
* Beispiel: ``"cockpit"``

##### install
* Datentyp: String Array
* Inhalt: Liste aller Dogus, die installiert werden sollen
* Beispiel: ``[
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
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Dogu-Schritt komplett ist
* Beispiel: ``true``


#### Admin-Schritt
Diese Einstellungen sind, bis auf _adminGroup_, nur relevant, sofern ein "embedded" User Backend gewählt wurde. Anderenfalls sind die Vorgaben des externen User Backends gültig.
Objektname: _admin_

Eigenschaften:

##### mail
* Datentyp: String
* Inhalt: E-Mail-Adresse des Admin-Kontos
* Beispiel: ``"admin@mydomain.com"``

##### username
* Datentyp: String
* Inhalt: Name des Admin-Kontos
* Beispiel: ``"admin"``

##### password
* Datentyp: String
* Inhalt: Passwort des Admin-Kontos

##### confirmPassword
* Datentyp: String
* Inhalt: Erneute Eingabe des Passworts des Admin-Kontos zur Bestätigung

##### adminGroup
* Datentyp: String
* Inhalt: Name der Gruppe im User Backend, die Administratorrechte im Ecosystem erhalten soll
* Diese Einstellung ist auch zu setzen, wenn ein externes User Backend gewählt wurde
* Beispiel: ``"administrators"``

##### adminMember
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob das angelegte Admin-Konto auch Mitglied der unter _adminGroup_ definierten Gruppe im User Backend werden soll
* Beispiel: true

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Admin-Schritt komplett ist
* Beispiel: ``true``


#### registryConfig (optional)
An dieser Stelle lassen sich Werte definieren, die direkt in die Registry übernommen werden sollen. Hierfür gibt es keinen äquivalenten Schritt in der Setupoberfläche. Die hier definierten Werte werden unter ``/config/`` in der Registry des Ecosystems abgelegt.

Objektname: _registryConfig_

Enthält beispielsweise folgende Objekte:

##### \_global
* Inhalt: Globale Konfigurationsdaten
* Beispiel: ``{
"stage":"development"
}`` oder ``{
"stage":"production"
}``

##### jenkins
* Inhalt: Informationen über die Update-Site-URLs für Jenkins
* Beispiel:``{
  "updateSiteUrl": {
"url1":"jenkinsUpdateSiteURL1",
"url2":"jenkinsUpdateSiteURL2"
}
}``
