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
Der Inhalt der setup.json besteht aus Objekten, die den Titel des jeweiligen Setupschritts (bspw. 'region' oder 'admin') tragen. Diese Objekte beinhalten Eigenschaften, die die Werte beschreiben, die dem jeweiligen Setupschritt übergeben werden sollen.  

#### region-Schritt
Objektname: _region_

Eigenschaften:

##### locale
* Datentyp: String
* Inhalt: locale-Einstellung des Ecosystems
* Beispiel: "en_US.utf8"


##### timeZone
* Datentyp:
* Inhalt:
* Beispiel:

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der _region_-Schritt komplett ist
* Beispiel: true


#### naming-Schritt
Objektname: _naming_

Eigenschaften:

##### fqdn
* Datentyp:
* Inhalt:
* Beispiel:

##### hostname
* Datentyp:
* Inhalt:
* Beispiel:

##### domain
* Datentyp:
* Inhalt:
* Beispiel:

##### certificateType
* Datentyp:
* Inhalt:
* Beispiel:

##### certificate
* Datentyp:
* Inhalt:
* Beispiel:

##### certificateKey
* Datentyp:
* Inhalt:
* Beispiel:

##### relayHost
* Datentyp:
* Inhalt:
* Beispiel:

##### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der _naming_-Schritt komplett ist
* Beispiel: true


#### dogus-Schritt

#### admin-Schritt

#### userBackend-Schritt

#### unixUser-Schritt

#### registryConfig-Schritt
