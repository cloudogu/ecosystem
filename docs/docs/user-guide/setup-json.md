## Automatisierung des Cloudogu Ecosystem Setupprozesses
Der Setupmechanismus des Cloudogu Ecosystem lässt sich mithilfe einer 'setup.json' benannten Konfigutarionsdatei automatisieren. Diese muss im Ordner  ::::: liegen und nach dem JSON-Standard formatiert sein. Alle Daten, die in dieser Datei definiert werden, werden automatisch im Setupprozess in die entsprechenden Felder eingetragen.

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
Der Inhalt der setup.json besteht aus Objekten, die den Titel des jeweiligen Setupschritts (bspw. 'region' oder 'admin') tragen. Diese Objekte beinhalten Eigenschaften, die die Werte beschreiben, die dem jeweiligen Setupschritt übergeben werden sollen. Ist das _completed_-Objekt auf ``true`` gesetzt, werden die Eigenschaften übernommen und der Schritt im Setupvorgang nicht mehr angezeigt.

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
* Beispiel: ``www.myecosystem.com``

##### hostname
* Datentyp: String
* Inhalt: Hostname des Ecosystems
* Beispiel: ``"ces"``

##### domain
* Datentyp: String
* Inhalt: DOmain des Ecosystems
* Beispiel: ``"ces.local"``

##### certificateType
* Datentyp: String
* Inhalt: Art des Zertifikats für die Verschlüsselung der HTTP-Verbindung zum Ecosystem
* ``"selfsigned"`` oder ``"external"``

##### certificate
* Nur notwendig, wenn certificateType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Das Zertifikat für das Ecosystem im PEM-Format

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
* Inhalt: Typ des User Backends. Bei Benutzung von ``embedded`` wird ein ldap-Dogu installiert, welches sich dann (optional) mithilfe des Usermanagement-Dogus verwalten lässt. Bei Benutzung von ``external`` sind die Zugangsdaten für ein externes User Backend zu übergeben.
* ``"external"`` oder ``"embedded"``

##### server
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Typ des User Backend Servers
* ``"activeDirectory"`` oder ``"custom"``

##### attributeID
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt:

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
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Attributname, der im User Backend den vollen Namen beschreibt
* Beispiel: ``"fullname"``

##### attributeMail
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Attributname, der im User Backend das E-Mail-Attribut beschreibt
* Beispiel: ``"mail"``

##### attributeGroup
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt:
* Beispiel:

##### baseDN
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: A base dn is the point from where a server will search for users.
* beispiel: dc=triobs1,dc=local (evtl zu groß)

##### searchFilter
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Einschränkung, nach welchen Objektklassen gesucht werden soll
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
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Adresse des externen User Backends

##### port
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: Port, über den das externe User Backend erreicht werden kann

##### loginID
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt: siehe _connectionDN_

##### loginPassword
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt:

##### encryption
* Nur notwendig, wenn dsType auf "external" gesetzt wurde
* Datentyp: String
* Inhalt:
* Beispiel: ``"none"``, ``"ssl"``, ``"sslAny"``, ``"startTLS"``, ``"startTLSAny"``

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Users-Schritt komplett ist
* Beispiel: ``true``

##### useUserConnectionToFetchAttributes
* Datentyp: boolean
* Inhalt: Wahrheitswert, ....???
* Beispiel: ``true``


#### Dogu-Schritt
Objektname: _dogus_

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
Objektname: _admin_

Eigenschaften:

##### username
* Datentyp: String
* Inhalt: Name des Admin-Kontos
* Beispiel: ``admin``

##### mail
* Datentyp: String
* Inhalt: E-Mail-Adresse des Admin-Kontos
* Beispiel: ``admin@mydomain.com``

##### password
* Datentyp: String
* Inhalt: Passwort des Admin-Kontos

##### confirmPassword
* Datentyp: String
* Inhalt: Erneute Eingabe des Passworts des Admin-Kontos zur Bestätigung

##### adminGroup
* Datentyp: String
* Inhalt: Name der Gruppe im User Backend, die Administratorrechte im Ecosystem erhalten soll
* Beispiel: ``administrators``

##### adminMember
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob das angelegte Admin-Konto auch Mitglied der unter _adminGroup_ definierten Gruppe im User Backend werden soll
* Beispiel: true

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Admin-Schritt komplett ist
* Beispiel: ``true``


#### registryConfig
Hier lassen sich einige Einstellungen tätigen, die nicht über die Weboberfläche des Setupprozesses abgefragt werden.

Objektname: _registryConfig_

Enthält folgende Objekte:

##### \_global
* Inhalt: Globale Konfigurationsdaten
* Beispiel: ``{
"stage":"development"
}`` oder ``{
"stage":"production" ??????????
}``

##### jenkins
* Inhalt: Informationen über die Update-Site-URLs für Jenkins
* Beispiel:``{
"url1":"jenkinsUpdateSiteURL1",
"url2":"jenkinsUpdateSiteURL2"
}``
