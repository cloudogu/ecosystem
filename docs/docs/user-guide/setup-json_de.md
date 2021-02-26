# Automatisierung des Cloudogu EcoSystem Setup-Prozesses
Der Setupmechanismus des Cloudogu EcoSystem lässt sich auf verschiedene Arten ausführen. Ein Weg führt über die Oberfläche im Browser, in der man alle relevanten Daten eingeben und Optionen auswählen kann. Des weiteren kann man mithilfe einer **setup.json** benannten Konfigurationsdatei die Felder im Setup vorbefüllen. Diese Datei muss im Ordner ``/vagrant`` oder ``/etc/ces`` liegen und nach dem JSON-Standard formatiert sein. Alle Daten, die in dieser Datei definiert werden, werden automatisch im Setupprozess in die entsprechenden Felder eingetragen. Sind alle Daten und Einstellungen für das Setup im Voraus klar, kann man das Setup auch komplett automatisch ablaufen lassen. Dafür ist für jeden Schritt die Eigenschaft *"completed"* zu setzen (siehe unten) und der Registrierungsschritt im Setup muss bereits vor dem Platzieren der setup.json abgeschlossen sein.

Beispiel:

```
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
```

Der Inhalt der setup.json besteht aus Objekten, die den Titel des jeweiligen Setup-Schrittes (bspw. 'region' oder 'admin') tragen. Diese Objekte beinhalten Eigenschaften, welche die Werte beschreiben, die dem jeweiligen Setup-Schritt übergeben werden sollen. Ist die *"completed"*-Eigenschaft auf `true` gesetzt, werden die Eigenschaften übernommen und der Schritt im Setupvorgang nicht mehr angezeigt.

Darüber hinaus existieren weitere Konfigurationsmöglichkeiten innerhalb der setup.json, die keinen äquivalenten Bereich im Browser-Setup besitzen und damit nur über die Datei vorkonfiguriert werden können. Im Folgenden finden sich alle Anpassungsmöglichkeiten je nach Konfigurationstyp.

## Konfigurationsschritte des Setups

### Bereich "Region"

Objektname: _region_

Eigenschaften:

#### locale
* Datentyp: String
* Inhalt: locale-Einstellung des EcoSystem
* Beispiel: `"en_US.utf8"`


#### timeZone
* Datentyp: String
* Inhalt: Zeitzone des EcoSystem
* Beispiel: `"Europe/Berlin"`


#### keyboardLayout
* Datentyp: String
* Inhalt: Keyboard Layout für die CES Instanz
* Beispiel: `"de"`


#### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Region-Schritt komplett ist
* Beispiel: `true`


### Bereich "Naming"

Objektname: _naming_

Eigenschaften:

#### fqdn
* Datentyp: String
* Inhalt: Vollständige Domain des EcoSystem
* Beispiel: `"www.myecosystem.com"`
* Hinweis: Es ist möglich, für die *"fqdn"* den Platzhalter `"<<ip>>"` einzutragen. Dadurch wird beim Ausführen des Setups die IP-Adresse des EcoSystem an dieser Stelle verwendet.

#### hostname
* Datentyp: String
* Inhalt: Hostname des EcoSystem
* Beispiel: `"ces"`

#### domain

* Datentyp: String
* Inhalt: Domain des EcoSystem
* Beispiel: `"ces.local"`

#### certificateType
* Datentyp: String
* Inhalt: Art des Zertifikats für die Verbindung zum EcoSystem
* Beispiel: `"selfsigned"` oder `"external"`

#### certificate
* Nur notwendig, wenn *"certificateType"* auf `"external"` gesetzt wurde
* Datentyp: String
* Inhalt: Das Zertifikat für das EcoSystem im PEM-Format. Sollte ein Intermediate-Zertifikat eingesetzt werden, muss auch dieses hier eingetragen werden.

#### certificateKey
* Nur notwendig, wenn *"certificateType"* auf `"external"` gesetzt wurde
* Datentyp: String
* Inhalt: Der Zertifikatsschlüssel für das EcoSystem im PEM-Format

#### relayHost

* Datentyp: String
* Inhalt: Der Mail Relay Host für das EcoSystem über den der Mailversand abgewickelt werden soll
* Beispiel: `"mail.mydomain.com"`

#### mailAddress
* Optional
* Datentyp: String
* Inhalt: Die Mail-Adresse, welche von allen Dogus verwendet wird, um Mails zu versenden (das 'From:'-Feld)
* Beispiel: `"mail@mydomain.com"`

#### useInternalIp
* Optional
* Datentyp: boolean
* Inhalt: Dieser Schalter gibt an, ob eine spezifische IP-Adresse für eine interne DNS-Auflösung des Hosts verwendet werden soll. Wenn dieser Schalter auf `true` gesetzt wird, dann erzwingt dies, einen gültigen Wert im Feld `internalIp`. Wenn dieses Feld nicht gesetzt wurde, dann wird es mit `false` interpretiert und ignoriert. 
* Beispiel: `"useInternalIp": true`

#### internalIp
* Optional 
* Datentyp: String
* Inhalt: Wenn und nur wenn `userInternalIp` wahr ist, wird die hier hinterlegte IP-Adresse für eine interne DNS-Auflösung des Hosts verwendet. Ansonsten wird dieses Feld ignoriert. Dies ist besonders für Installationen mit einer Split-DNS-Konfiguration interessant, d. h. wenn die Instanz von außen mit einer anderen IP-Adresse erreichbar ist, als von innen. 
* Beispiel: `"internalIp": "10.0.2.15"`

#### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Naming-Schritt komplett ist
* Beispiel: `true`


### Bereich "UserBackend"

Objektname: _userBackend_

Eigenschaften:

#### dsType
* Datentyp: String
* Inhalt: Typ des User Backends. Bei Benutzung von `"embedded"` wird ein ldap-Dogu installiert, welches sich dann (optional) mithilfe des User Management-Dogus verwalten lässt. Bei Benutzung von `"external"` sind die Zugangsdaten für ein externes User Backend zu übergeben.

#### server
* Nur notwendig, wenn *"dsType"* auf `"external"` gesetzt wurde
* Datentyp: String
* Inhalt: Typ des User Backend Servers
* `"activeDirectory"` oder `"custom"`

#### attributeID
* Datentyp: String
* Inhalt: Attributname, der im User Backend die User ID beschreibt
* Muss auf `"uid"` gesetzt werden, wenn *"dsType"* auf `"embedded"` gesetzt wurde
* Muss auf `"sAMAccountName"` gesetzt werden, wenn *"dsType"* auf `"external"` und *"server"* auf `"activeDirectory"` gesetzt wurde

#### attributeGivenName
* Nur notwendig, wenn *"dsType"* auf `"external"` gesetzt wurde
* Datentyp: String
* Inhalt: Attributname, der im User Backend den Vornamen beschreibt
* Beispiel: `"givenname"`

#### attributeSurname
* Nur notwendig, wenn *"dsType"* auf `"external"` gesetzt wurde
* Datentyp: String
* Inhalt: Attributname, der im User Backend den Nachnamen beschreibt
* Beispiel: `"surname"`

#### attributeFullname
* Datentyp: String
* Inhalt: Attributname, der im User Backend den vollen Namen beschreibt
* Muss auf `"cn"` gesetzt werden, wenn *"dsType"* auf `"embedded"` oder *"server"* auf `"activeDirectory"` gesetzt wurde
* Beispiel: `"fullname"`

#### attributeMail
* Datentyp: String
* Inhalt: Attributname, der im User Backend das E-Mail-Attribut beschreibt
* Muss auf `"mail"` gesetzt werden, wenn *"dsType"* auf `"embedded"` oder *"server"* auf `"activeDirectory"` gesetzt wurde
* Beispiel: `"mail"`

#### attributeGroup
* Datentyp: String
* Inhalt: Attributname, mit dem im User Backend die Zugehörigkeit eines Users zu einer Gruppe geregelt wird
* Muss auf `"memberOf"` gesetzt werden, wenn *"dsType"* auf `"embedded"` oder *"server"* auf `"activeDirectory"` gesetzt wurde
* Beispiel: `"memberOf"`

#### baseDN
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Distinguished Name von der aus auf dem Server nach Benutzern gesucht wird
* Beispiel: `"dc=mycomp1,dc=local"`

#### searchFilter
* Datentyp: String
* Inhalt: Einschränkung, nach welchen Objektklassen gesucht werden soll
* Muss auf `"(objectClass=person)"` gesetzt werden, wenn *"dsType"* auf `"embedded"` oder *"server"* auf `"activeDirectory"` gesetzt wurde
* Beispiel: `"(objectClass=person)"`

#### connectionDN
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Distinguished Name eines leseberechtigten Benutzers im User Backend
* Beispiel: `"username@mycompany.local"` oder `"cn=username,dc=users,dc=mycomp,dc=local"`

#### password
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Passworts des unter *"connectionDN"* gesetzten Nutzers

#### host
* Datentyp: String
* Inhalt: Adresse des externen User Backends
* Muss auf `"ldap"` gesetzt werden, wenn *"dsType"* auf `"embedded"`  gesetzt wurde

#### port
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Port, über den das externe User Backend erreicht werden kann
* Muss auf `"389"` gesetzt werden, wenn *"dsType"* auf `"embedded"`  gesetzt wurde

#### encryption

* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Einstellung ob und ggf. welche Verschlüsselung genutzt werden soll
* Beispiel: `"none"`, `"ssl"`, `"sslAny"`, `"startTLS"`, `"startTLSAny"`

#### groupBaseDN
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des Distinguished Name für das Group Mapping

#### groupSearchFilter
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe von Suchfiltern für das Group Mapping

#### groupAttributeName
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des name Attributs für das Group Mapping

#### groupAttributeDescription
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des description Attributs für das Group Mapping

#### groupAttributeMember
* Nur notwendig, wenn *"dsType"* auf `"external"`  gesetzt wurde
* Datentyp: String
* Inhalt: Angabe des member Attributs für das Group Mapping

#### useUserConnectionToFetchAttributes
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der jeweils angemeldete Nutzer zur Abfrage der Attribute aus dem User Backend genutzt werden soll
* Muss auf `true` gesetzt werden, wenn *"dsType"* auf `"embedded"` oder *"server"* auf `"activeDirectory"` gesetzt wurde
* Beispiel: `true`

#### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der User-Schritt komplett ist
* Beispiel: `true`

### Bereich "Dogus"

Die Daten, die in diesem Schritt über die setup.json eingegeben werden, werden im Setup-Prozess nur übernommen, wenn die _completed_-Eigenschaft auf `true` gesetzt ist. Anderenfalls ist der Schritt manuell über die Weboberfläche auszufüllen.

Objektname: _dogus_

Eigenschaften:

#### defaultDogu
* Datentyp: String
* Inhalt: Name des Dogus, welches beim Aufruf des EcoSystem im Browser standardmäßig angesteuert wird
* Beispiel: `"cockpit"`

#### install
* Datentyp: String Array
* Inhalt: Liste aller Dogus, die installiert werden sollen. Einträge können die zu installierende Version enthalten; wenn keine Version gesetzt ist, wird die aktuellste Version installiert.
* Beispiel: 
````
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
````

#### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Dogu-Schritt komplett ist
* Beispiel: `true`

### Bereich "Projects"

Objektname: _projects_

Eigenschaften:

#### import
* Datentyp: Project Array
* Inhalt: Liste aller Projekte, die importiert werden sollen.

##### Datentyp Project
###### username
* Datentyp: string
* Inhalt: Der Nutzername für die Authentifizierung bei dem Dienst (z.B. GitHub), von dem das zu importierende Projekt abgerufen wird.

###### password
* Datentyp: string
* Inhalt: Das Passwort für die Authentifizierung bei dem Dienst (z.B. GitHub), von dem das zu importierende Projekt abgerufen wird.

###### type
* Datentyp: string
* Inhalt: Der Typ des Dienstes, von dem das zu importierende Projekt abgerufen wird.
* Mögliche Werte: Git

###### location
* Datentyp: string
* Inhalt: Der Ort, an dem das Projekt gespeichert ist, z.B. eine URL zu einem Git-Repository
* Beispiel: https://github.com/cloudogu/demo-content-petclinic

###### reference
* Datentyp: Reference
* Inhalt: Eine Referenz auf einen bestimmten Branch oder einen bestimmten Tag
* Optional
* If no reference is specified, the default branch of the repository is used.

##### Datentyp Reference
###### name
* Datentyp: string
* Inhalt: Eine Referenz auf einen Branch oder Tag
* Beispiel: feature/123_myBranch

###### type
* Datentyp: string
* Inhalt: Der Typ der Referenz
* Mögliche Werte: Tag, Branch

##### Example:
````
"projects":{
  "import":[
    {
      "username":"<username>",
      "password":"<password>",
      "type":"Git",
      "location":"https://github.com/cloudogu/demo-content-petclinic",
      "reference":{
        "name":"0.0.1",
        "type":"Tag"
      }
    }
  ],
  "completed":true
},
````

#### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Projects-Schritt komplett ist
* Beispiel: `true`

### Bereich "Admin"

Diese Einstellungen sind, bis auf *"adminGroup"*, nur relevant, sofern ein "embedded" User Backend gewählt wurde. Anderenfalls sind die Vorgaben des externen User Backends gültig.

Objektname: _admin_

Eigenschaften:

#### mail
* Datentyp: String
* Inhalt: E-Mail-Adresse des Admin-Kontos
* Beispiel: `"admin@mydomain.com"`

#### username
* Datentyp: String
* Inhalt: Name des Admin-Kontos
* Beispiel: `"admin"`

#### password
* Datentyp: String
* Inhalt: Passwort des Admin-Kontos

#### adminGroup
* Datentyp: String
* Inhalt: Name der Gruppe im User Backend, die Administratorrechte im EcoSystem erhalten soll
* Diese Einstellung ist auch zu setzen, wenn ein externes User Backend gewählt wurde.
* Beispiel: `"administrators"`

#### adminMember

* Datentyp: boolean
* Inhalt: Wahrheitswert, ob das angelegte Admin-Konto auch Mitglied der unter *"adminGroup"* definierten Gruppe im User Backend werden soll
* Beispiel: `true`

#### completed
* Datentyp: boolean
* Inhalt: Wahrheitswert, ob der Admin-Schritt komplett ist
* Beispiel: `true`

### Bereich "UnixUser"

Mit dieser Einstellung können sie das Passwort für den im Setup erzeugten Systemadministrator `ces-admin` konfigurieren.
Ohne diese Einstellung wird ein zufällig generiertes Passwort erzeugt, welches am Ende des Setups angezeigt wird. 
Über die Oberfläche ist das Passwort des Systemadministrator nicht konfigurierbar.

Objektname: *unixUser*

#### Password

* Datentyp: string
* Inhalt: Password des Unixusers
* Beispiel: `"ces-password"`

## Zusätzliche Konfigurationsparameter

#### sequentialDoguStart (optional)

Ist dieser boolsche Wert auf `true` gesetzt, werden die Dogus am Ende des Setups nicht parallel alle auf einmal gestartet, sondern einzeln. Es wird dabei so lange auf das startende Dogu gewartet, bis es sich in einem _healthy_ state befindet.

Objektname: _sequentialDoguStart_

#### extendedConfiguration (optional)

Dieser Bereich enthält erweiterte Konfigurationsoptionen für das CES-setup.

##### ignoreCriticalHealthCheck (optional)
- Datentyp: boolean
- Inhalt: Diese boolsche Option sorgt dafür, dass Healthcheck-Fehler, die während des Starts von Dogus am Ende des Setup auftreten, nur geloggt werden, aber nicht zu einem Abbruch des Setups führen.
- Beispiel: `{ "ignoreCriticalHealthCheck": true }`

#### registryConfig (optional)
An dieser Stelle lassen sich Werte definieren, die direkt in die Registry übernommen werden sollen. Hierfür gibt es keinen äquivalenten Schritt in der Setup-Oberfläche. Die hier definierten Werte werden unter ``/config/`` in der Registry (etcd) des EcoSystem abgelegt.

Objektname: _registryConfig_

Enthält beispielsweise folgende Objekte:

##### \_global
* Inhalt: Globale Konfigurationsdaten
* Beispiel: `{
"stage":"development",
"manager_group": "cesManager"
}` oder `{
"stage":"production"
}`

##### containers/additional_hosts
- Inhalt: Host-Einträge für alle dogus
- Beispiel:
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

Hostnamen dürfen nicht mehrfach vorkommen. 
Außerdem darf derselbe Hostname nicht in der Konfiguration der Cesapp und in der globalen Konfiguration konfiguriert sein.

##### Bereich `config/_global/proxy`

Hier kann ein Proxy-Server konfiguriert werden, der unter anderem für die Kommunikation mit der Dogu-Registry 
und der Docker-Registry verwendet wird.
Hinweis: Der Docker-Service muss neu gestartet werden, damit die Änderungen Anwendung finden.

###### `enabled`

* Datentyp: bool
* Inhalt: Bestimmt, ob die Proxy-Einstellungen übernommen werden (`true`) oder nicht (`false` / nicht gesetzt).

###### `server`

* Datentyp: string
* Inhalt: Die IP-Addresse des Servers (z.B `192.168.56.2` oder `www.example.com`)

###### `port`

* Datentyp: string
* Inhalt: Der Port des Servers (z.B `3128`)

###### `username`

* Optional
* Datentyp: string
* Inhalt: Der Nutzername für die Authentifizierung auf dem Server

###### `password`

* Optional
* Datentyp: string
* Inhalt: Das Passwort für die Authentifizierung auf dem Server

###### `no_proxy`

* Optional
* Datentyp: string
* Inhalt: Kommaseparierte Liste mit Hosts, die den Proxy-Server nicht benötigen (z.B. `*.test.example.com,.example2.com'`).

##### Alle Dogus

Einträge in dieser Kategorie lassen sich für alle Dogus konfigurieren. 
Dafür muss der Konfigurationsschlüssel immer in Relation zum Konfigurationspfad des Dogus erstellt werden.

###### `<dogu_config_path>/container_config/memory_limit`

* Optional
* Datentyp: string
* Inhalt: Limitiert den physikalischen Speicher des Dogus.
  Muss ein positiver Integer mit eine der folgenden Einheiten sein [b,k,m,g] (Byte, Kibibyte, Mebibyte, Gibibyte).
  (z.B. `2g (2 Gibibyte),750m (750 Mebibyte)'`).
  
###### `<dogu_config_path>/container_config/swap_limit`

* Optional
* Voraussetzung: Wert für `container_config/memory_limit` ist gesetzt
* Datentyp: string
* Inhalt: Limitiert den Swap-Bereich des Dogu-Containers.
  Muss ein positiver Integer mit eine der folgenden Einheiten sein [b,k,m,g] (Byte, Kibibyte, Mebibyte, Gibibyte).
  (z.B. `2g (2 Gibibyte),750m (750 Mebibyte)'`).
  Der Wert `0b` deaktiviert den Swap komplett für das Dogu.
  
##### backup

- Inhalt: Konfiguration des Backup- und Restore-Mechanimus
- Beispiel: 

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
  
  Wenn der Wert auf `true` gesetzt ist, sind die Backups an eine blueprintId gebunden. 
  Nach einem Blueprint-Upgrade können sie nicht wiederhergestellt werden.
  Wenn der Wert auf `false` oder gar nicht gesetzt ist, können alle Backups wiederhergestellt werden.

    
- Key: `"pre_backup_script"`
  
  Hier kann der Pfad zu einem Bash-Script hinterlegt werden. 
  Der Pfad darf nicht leer sein. Es muss ein absoluter Pfad sein. Das Script muss existieren und ausführbar sein.
  Das so hinterlegte Script wird vor jedem Backup ausgeführt.
  
- Key: `"post_backup_script"`
  
  Hier kann der Pfad zu einem Bash-Script hinterlegt werden. 
  Der Pfad darf nicht leer sein. Es muss ein absoluter Pfad sein. Das Script muss existieren und ausführbar sein.
  Das so hinterlegte Script wird nach jedem erfolgreichen Backup ausgeführt.
  
- Key: `"pre_restore_script"`
  
  Hier kann der Pfad zu einem Bash-Script hinterlegt werden. 
  Der Pfad darf nicht leer sein. Es muss ein absoluter Pfad sein. Das Script muss existieren und ausführbar sein.
  Das so hinterlegte Script wird vor jedem Restore ausgeführt.
  
- Key: `"post_restore_script"`
  
  Hier kann der Pfad zu einem Bash-Script hinterlegt werden. 
  Der Pfad darf nicht leer sein. Es muss ein absoluter Pfad sein. Das Script muss existieren und ausführbar sein.
  Das so hinterlegte Script wird nach jedem erfolgreichen Restore ausgeführt.
  
  
  
##### cas

- Key: ` "limit/max_number"`

  Setzt die maximal erlaubte Anzahl an Fehlversuchen pro Benutzerkonto.
  Wird diese Anzahl innerhalb des mit den weiteren Parametern definierten zeitlichen Rahmen
  überschritten, wird das Konto temporär gesperrt.

  Wird der Wert auf `0` gesetzt, ist das Feature deaktiviert und es findet keine Limitierung statt.
  Bei einem Wert größer Null müssen die anderen Parameter auf sinnvolle Werte gesetzt werden. 

- Key: `"limit/failure_store_time"`

  Spezifiziert die Zeitdauer, für die die Anzahl der Fehlschläge seit dem letzten
  fehlgeschlagenen Anmeldeversuch gespeichert werden soll. Wird diese Zeit zwischen zwei Anmeldeversuchen überschritten,
  werden die Fehlschläge zurückgesetzt.

  Die Zeit wird in Sekunden angegeben und muss größer Null sein, wenn das Feature aktiviert ist.

- Key: `"limit/lock_time"`

  Gibt an, wie lange das Konto im Falle einer Überschreitung der Anmeldeversuche gesperrt werden
  soll.

  Die Zeit wird in Sekunden angegeben und muss größer Null sein, wenn das Feature aktiviert ist.

- Key: `"forgot_password_text"`

  Der anzuzeigende Text bei Klick auf "Passwort vergessen" innerhalb der Anmeldemaske.

- Key: `"legal_urls/terms_of_service"`

   Enthält URLs für die Nutzungsbedingungen. Wenn der Key nicht existiert oder der Wert leer ist, dann wird der Link "Nutzungsbedingungen" nicht angezeigt. Das CAS Dogu muss neugestartet werden, damit eine geänderte URL wirksam werden kann.
 
- Key: `"legal_urls/imprint"`

   Enthält URLs für das Impressum. Wenn der Key nicht existiert oder der Wert leer ist, dann wird der Link "Impressum" nicht angezeigt. Das CAS Dogu muss neugestartet werden, damit eine geänderte URL wirksam werden kann.

- Key: `"legal_urls/privacy_policy"`

   Enthält URLs für die Datenschutzerklärung. Wenn der Key nicht existiert oder der Wert leer ist, dann wird der Link "Datenschutzerklärung" nicht angezeigt. Das CAS Dogu muss neugestartet werden, damit eine geänderte URL wirksam werden kann.
  
  
##### cockpit
- Key: `"welcomeDashboard"`

Die Konfiguration des Welcome-Dashboards kann hier gesetzt werden
* Beispiel:
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

* Anmerkung: Wenn diese Definition nicht oder nicht in korrektem JSON-Format gesetzt ist, wird das default-Dashboard angezeigt.
* Anmerkung: Die maximale Größe, die die JSON-Beschreibung des Dashboards haben darf, ist 2MB.

- Key: `"pinnedDashboard"`

Die Konfiguration des Pinned-Dashboards kann hier gesetzt werden. Dieses wird jedem Nutzer des Cockpits angezeigt und kann nicht verändert oder verschoben werden. Für Format und Einschränkungen siehe `welcomeDashboard`.

##### confluence

* Inhalt: Hier kann eine Benutzergruppe aus dem CES angegeben werden, die in Confluence die Rolle `Confluence Users` erhalten soll.
* Beispiel:

```
"registryConfig": {
    "confluence": {
      "confluence_users_group": "my-group-name"
    }
}
```

* Inhalt: Hier kann ein Lizenzschlüssel angegeben werden, der beim ersten Start des Dogus eingespielt wird.
* Beispiel:

```
"registryConfig": {
    "confluence": {
      "license_key": "my-valid-license-key"
    }
}
```

* Inhalt: Legt das Intervall in Sekunden für die Synchronisierung des LDAP Benutzerverzeichnis-Caches fest. [Standard: 3600]
* Beispiel:

```
"registryConfig": {
    "confluence": {
      "ldap/sync_interval": "600"
    }
}
```

* Inhalt: Legt die globale Standardsprache fest. [Standard: de_DE]
* Beispiel:

```
"registryConfig": {
    "confluence": {
      "settings/global_language": "en_GB"
    }
}
```

* Inhalt: Hier kann definiert werden, ob die Nutzungsanalyse aktiviert sein soll. [Standard: false]
* Beispiel:

```
"registryConfig": {
    "confluence": {
      "settings/enable_analytics": "true"
    }
}
```

* Inhalt: Hier kann definiert werden, ob die Mobile App Zugriff auf Confluence haben soll. [Standard: true]
* Beispiel:

```
"registryConfig": {
    "confluence": {
      "settings/enable_mobile_plugin": "false"
    }
}
```

* Inhalt: Hier können weitere Verknüpfungen als Hilfe für die Erstellung von Links zu anderen Webinhalten angegeben werden.
* Beispiel:

```
"registryConfig": {
    "confluence": {
      "settings/additional_shortcuts": "[{\"name\": \"my-shortcut-name\", \"expandedValue\": \"expample-url\", \"defaultAlias\": \"example-alias\"}]"
    }
}
```

##### jenkins

* Key `updateSiteUrl`: Informationen über die Update-Site-URLs für Jenkins
* Key `additinal.plugins`: Installation von weiteren Plugins beim Start. Konfiguriert als kommaseparierte Liste.
* Beispiel:
````
{
  "updateSiteUrl": {
    "url1":"jenkinsUpdateSiteURL1",
    "url2":"jenkinsUpdateSiteURL2"
  }
  "additional.plugins": "docker-plugin,docker-workflow"
}
````

##### nexus
* Inhalt: Option zum Verhindern der Erstellung der Default Docker Registry
* Beispiel:`{
    "installDefaultDockerRegistry": "false"
}`

* Inhalt: Option zum Aktivieren von Repository Sandboxing
* Beispiel:`{
    "nexus.repository.sandbox.enable": "true"
}`

* Inhalt: Option zum Deaktivieren der Outreach Management Capability und dadurch des Willkommen-Fensters
* Beispiel:`{
    "disableOutreachManagement": "true"
}`

* Inhalt: Optionen zum Importieren von HTTP/HTTPS-Proxy-Einstellungen und davon ausgenommenen Hosts
* Beispiel:
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

* Inhalt: Externe Links, die im Warp-Menü auftauchen sollen
* Beispiel:
````
{
  "cloudogu": "{
    \"DisplayName\": \"Cloudogu\",
    \"Description\": \"Beschreibungstext für Cloudogu Webseite\",
    \"Category\": \"External Links\",
    \"URL\": \"https://www.cloudogu.com/\"
  }"
}
````

###### `html_content_url`

* Optional
* Datentyp: string
* Default: `static`
* Inhalt: URL-Pfad-Prefix um alle benutzerdefinierte Seiten zu erreichen, welche mit Nginx zur Verfügung gestellt werden
  URL path to reach all custom html content pages deployed with Nginx.

###### `ignore_service_health`

* Optional
* Datentyp: Boolean
* Default: `false`
* Inhalt: Entscheidet ob Nginx den HealthStatus der Dogus ignoriert und somit den Zugriff auf `unhealty` Dogus ermöglicht. 
  Standardmäßig sind diese Dogus nicht erreichbar. 

##### nexus/claim

* Datentyp: String, HCL/JSON formatiert
* Inhalt: Konfiguration der Sonatype Nexus-Repositories. Diese Einstellung wird beim ersten ("once") bzw. jedem ("always") Start von Sonatype Nexus hergestellt. Die genaue Definition der Nexus-Properties ist der Nexus-Dokumentation zu entnehmen.
* Weitere Informationen: https://github.com/cloudogu/nexus-claim
* [Beispiel für Nexus 2 \[Link\]](https://github.com/cloudogu/nexus-claim/blob/develop/resources/nexus2/nexus-initial-example.hcl)
* [Beispiel für Nexus 3 \[Link\]](https://github.com/cloudogu/nexus-claim/blob/develop/resources/nexus3/nexus_custom.hcl)

* _state: Je nach gesetztem State werden Repositories hinzugefügt/geändert oder entfernt. Ist der State auf `"absent"` gesetzt, wird ein ggf. vorhandenes Repository mit der genannten ID gelöscht. Ist der State auf `"present"` gesetzt, wird ein neues Repository angelegt, falls es noch nicht existiert. Sollte es schon existieren, werden nur die Eigenschaften, bspw. der Name, angepasst.

##### postfix
* Inhalt: Konfiguration der TLS-Verschlüsselung des Postfix SMTP Client
* Für weiterführende Informationen siehe [offizielle Postfix Dokumentation](http://www.postfix.org/documentation.html)

- Verwendung innerhalb der setup.json:

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
* Inhalt: Hier kann die SonarQube UpdateCenter URL und eine Liste von Standardplugins gesetzt werden
* Beispiel:
```
{
    "sonar.updatecenter.url": "http://customupdatecenter.com",
    "sonar.plugins.default": "pmd,jacoco"
}
```

##### scm

* Inhalt: Hier können die Plugin Center URL, die Release Feed URL und die Standard Plugins definiert werden. Die Standard Plugins werden bei jedem Start installiert, falls sie fehlen.
* Zum deaktivieren der regelmäßigen Suche nach neuen Versionen kann `disable_release_feed` auf `true` gesetzt werden.
* Beispiel:

```
{
  "plugin_center_url": "https://plugin-center-api.scm-manager.org/api/v1/plugins/2.0.0",
  "release_feed_url": "https://scm-manager.org/download/rss.xml",
  "additional_plugins": "scm-landingpage-plugin,scm-editor-plugin",
  "update_plugins": "true"
}
```

##### usermgt
* Inhalt: Hier können Passwortrichtlinien eingestellt werden, die sicherstellen, dass Passwörter einen gewissen Sicherheitsstandard erfüllen.  

- Die regulären Ausdrücke müssen ECMA Script kompatibel sein. Geprüft werden können die Ausdrücke z. B. mit [regex101](https://regex101.com/) Flavour: ECMA Script. 
- Wenn ein regulärer Ausdruck ungültig ist, dann kann der entsprechende Nutzer nicht neu angelegt werden bzw. der Benutzer kann seine Passwortänderung nicht übernehmen.
- Beispielwert aus der Registry (zur Übersicht):
```
{
  "password_policy": {
    "Rules": [
      {
        "Description": "Should contain at least 8 characters",
        "Rule": ".{8,}",
        "Type": "regex"
      },
      {
        "Description": "Should contain at least one digit",
        "Rule": "[0-9]",
        "Type": "regex"
      },
      {
        "Description": "Should contain at least one super special character",
        "Rule": "[\\"\\-\\[\\]]",
        "Type": "regex"
      }
    ]
  }
}
```

Vorsicht gilt, wenn Zeichen verwendet werden, denen eine besondere Bedeutung zukommt:
- Javascript/JSON
   - `"` als String-Delimiter
   - `\` als Escape-Zeichen
      - Vorsicht: Der ECMAScript-Standard verbietet ein Escaping beliebiger Zeichen. Wenn unbedingt bestimmte Zeichen verwendet werden sollen, bietet die ASCII Hex-Konvertierung eine Alternative an (siehe unten). 
- RegExp-Syntax
   - `[`, `]`, `-`, `\`, `|`, uvm.

Beispielsweise muss eine Regel für die Erzwingung der Sonderzeichen `"-[]` als `\\"\\-\\[\\]` umgeschrieben werden. Eine weitere Möglichkeit bietet die Umformulierung von Zeichen im Hexadezimalformat im Format `\xYY`. Obige Sonderzeichen lassen sich so umschreiben (auch hier wieder das Doppelescape beachten): `\\x22\\x2D\\x5B\\x5D`

Das JSON-Format der `setup.json` erlaubt keine nativen Newlines (`\n\r`) innerhalb von String-Properties. Zudem müssen Anführungszeichen innerhalb des Strings ebenfalls escaped werden. Da das Escapezeichen durch das JSON-Format erneut Anwendung findet,  muss jedes Backslash erneut escaped werden. D. h. `\\` muss zu `\\\\` umgewandelt werden.

Nach all diesen Transformationen sähe das obige Beispiel für die `setup.json` wiefolgt aus:

```
  "registryConfig": {
    "usermgt": {
      "password_policy": "{ \"Rules\": [ { \"Description\": \"Should contain at least 8 characters\", \"Rule\": \".{8,}\", \"Type\": \"regex\" }, { \"Description\": \"Should contain at least one digit\", \"Rule\": \"[0-9]\", \"Type\": \"regex\" }, { \"Description\": \"Should contain at least one super special character\", \"Rule\": \"[\\\\"\\\\-\\\\[\\\\]]\", \"Type\": \"regex\" } ] }"
    }
  }
```

##### jira

* Inhalt: Hier kann eine Benutzergruppe aus dem CES angegeben werden, die in Jira die Rolle `JIRA SOFTWARE` erhalten soll. [Standard: unbenutzt]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "jira_software_users_group": "my-group-name"
    }
  }
```

* Inhalt: Hier kann eine Benutzergruppe aus dem CES angegeben werden, die in Jira die Rolle `JIRA SERVICE DESK` erhalten soll. [Standard: unbenutzt]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "jira_service_desk_users_group": "my-group-name"
    }
  }
```

* Inhalt: Hier kann eine gültige Lizenz für Jira Software (Server) hinterlegt werden. Diese Lizenz wird nur beim initialen Setup des Dogus verwendet. [Standard: eine abgelaufene Testlizenz]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "license_key": "my-valid-license-key"
    }
  }
```

* Inhalt: Hier kann eine gültige Lizenz für Jira Service Desk (nun: Jira Service Management) hinterlegt werden. Diese Lizenz wird nur beim initialen Setup des Dogus verwendet. [Standard: eine abgelaufene Testlizenz]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "license_key_jsm": "my-valid-license-key"
    }
  }
```

* Inhalt: Legt das Intervall in Sekunden für die Synchronisierung des LDAP Benutzerverzeichnis-Caches fest. [Standard: 3600]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "ldap/sync_interval": "600"
    }
  }
```

* Inhalt: Konfiguriert Jiras Loggingverhalten. [Standard: WARN]
* Optional
* Gültige Werte: ERROR, WARN, INFO, DEBUG
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "logging/root": "ERROR"
    }
  }
```

* Inhalt: Legt fest, ob beim Start des Dogus benutzerdefinierte Skripte ausgeführt werden. [Standard: false]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "startup/enable_scripts": "true"
    }
  }
```

* Inhalt: Legt fest, ob die benutzerdefinierten Skripte mit einer Hintergrund-Instanz von Jira ausgeführt werden sollen. [Standard: false]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "startup/isolated_scripting_environment": "true"
    }
  }
```

* Inhalt: Begrenzt den Speicherverbrauch des Containers. [Standard: disabled]
* Optional
* Gültige Werte: Eine positive Ganzzahl gefolgt von einer dieser Einheiten [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte).
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "container_config/memory_limit": "1g"
    }
  }
```

* Inhalt: Begrenzt den Swap-Verbrauch des Containers. [Standard: disabled]
* Gültige Werte: Null oder eine positive Ganzzahl gefolgt von einer dieser Einheiten [b,k,m,g]. 0 deaktiviert Swapping.
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "container_config/swap_limit": "100m"
    }
  }
```

* Inhalt: Begrenzt die Größe des Heap-Stacks des Jira-Prozesses auf den konfigurierten Prozentsatz des verfügbaren physischen Speichers, wenn der Container über mehr als ca. 250 MB Speicher verfügt. Wird nur berücksichtigt, wenn ein `memory_limit` gesetzt ist. Verwenden Sie einen gültigen Gleitkommawert zwischen 0 und 100 mit 1 Dezimalstelle (z. B. 55.0 für 55 %). JIRA benötigt mindestens 786 MB als Heap-Größe. [Standard: 25.0]
* Optional
* Beispiel:

```
  "registryConfig": {
    "jira": {
      "container_config/java_max_ram_percentage": "55.0"
    }
  }
```


##### postgresql

* Inhalt: Hier kann die maximale Arbeitsspeichernutzung des Containers eingeschränkt werden. Die möglichen Einheiten sind [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte).
* Beispiel:

```
  "registryConfig": {
    "postgresql": {
      "container_config/memory_limit": "1g"
    }
  }
```

* Inhalt: Hier kann ein Limit für den swapping-Bereich eingestellt werden. Die möglichen Einheiten sind [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte).
* Beispiel:

```
  "registryConfig": {
    "postgresql": {
      "container_config/swap_limit": "100m"
    }
  }
```

#### registryConfigEncrypted (optional)

An dieser Stelle lassen sich Werte definieren, die in verschlüsselter Form in die Registry übernommen werden sollen. Hierfür gibt es keinen äquivalenten Schritt in der Setup-Oberfläche. Die hier definierten Werte werden unter ``/config/`` in der Registry des EcoSystem abgelegt. Anders als bei ``registryConfig``, können sich in der ersten Ebene nur installierte (bzw. während dem Setup installierte) Dogus befinden, da nur für diese eine Verschlüsselung möglich ist.

Objektname: _registryConfigEncrypted_

Enthält beispielsweise folgende Objekte:

##### postfix
* Inhalt: Postfix SMTP Client RSA Zertifikat im PEM-Format
* Beispiel: `{
  "smtp_tls_cert_file": "<CERTIFICATE>"
  }`
* Inhalt: Postfix SMTP Client RSA Private Key im PEM-Format
* Beispiel: `{
  "smtp_tls_key_file": "<PRIVATE KEY>"
  }`
* Verwendung innerhalb der setup.json:
````
"registryConfigEncrypted":{
	"postfix" : {
		"smtp_tls_cert_file": "<CERTIFICATE>",
		"smtp_tls_key_file": "<PRIVATE KEY>"
	}
}
````

##### swaggerui

```
  "registryConfig": {
    "swaggerui": {
      "validator_url": "https://validator.swagger.io/validator"
    }
  }
```

- Key: `"validator_url"`

  Die Url zum SwaggerValidator. Zum Nutzen des Standard-Validators muss dieser Wert auf `https://validator.swagger.io/validator`
  gesetzt werden. Wird der Wert nicht gesetzt oder enthält einen leeren String, wird der SwaggerValidator deaktiviert.
  
##### Portainer

###### Log-Level
* Etcd-Schlüssel-Pfad: `logging/root`
* Inhalt: Definiert die Granularität der Log-Ausgaben von Portainer
* Datentyp: String
* Valide Werte: `ERROR, WARN, INFO, DEBUG`

###### Physisches Speicherlimit
* Etcd-Schlüssel-Pfad: `container_config/memory_limit`
* Inhalt: Beschränkt den Speicher (RAM) des Docker-Containers für Portainer
* Datentyp: Binäre Speicherangabe
* Valide Werte: Ganzzahl gefolgt von [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte)
* Beispiel: `1750m` = 1750 MebiByte

###### Physisches Swaplimit
* Etcd-Schlüssel-Pfad: `container_config/swap_limit`
* Inhalt: Beschränkt den Swap des Docker-Containers für Portainer
* Datentyp: Binäre Speicherangabe
* Valide Werte: Ganzzahl gefolgt von [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte)
* Beispiel: `1750m` = 1750 MebiByte

###### Portainer Agenten
* Etcd-Schlüssel-Pfad: `agent_configuration`
* Inhalt: Beschreibt eine Menge an Portainer Agenten, welche zur Startzeit bei Portainer registriert werden sollen.
* Datentyp: String (JSON)
* JSON-Format: 
```json
[
    {
        "Name":"NAME",
        "EndpointURL":"ENDPOINTADDRESS:PORT"
    },
    {
        "Name":"ExampleAgent",
        "EndpointURL":"123.23.3.1:9001"
    }
]
```
