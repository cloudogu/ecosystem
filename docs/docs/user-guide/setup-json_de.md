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

Mit dieser Einstellung können die Credentials für den im Setup erzeugten Systemadministrator konfiguriert werden.
Ohne diese Einstellung wird ein Nutzer mit dem Namen *ces-admin* und einem zufällig generiertem Passwort erzeugt, welches am Ende des Setups angezeigt wird. Über die Oberfläche ist der Systemadministrator nicht konfigurierbar.

Objektname: *unixUser*

#### Name

* Datentyp: string
* Inhalt: Name des Unixusers
* Beispiel: `"ces-admin"`

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
* Inhalt: Die Konfiguration des Welcome-Dashboards kann hier gesetzt werden
* Beispiel:
````
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
````
* Anmerkung: Wenn diese Definition nicht oder nicht in korrektem JSON-Format gesetzt ist, wird das default-Dashboard angezeigt.
* Anmerkung: Die maximale Größe, die die JSON-Beschreibung des Dashboards haben darf, ist 2MB.

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

##### jira
* Inhalt: Hier kann eine Benutzergruppe aus dem CES angegeben werden, die in Jira die Rolle `JIRA SOFTWARE` erhalten soll.
* Beispiel:
```
  "registryConfig": {
    "jira": {
      "jira_software_users_group": "my-group-name"
    }
  }
```
* Inhalt: Legt das Intervall in Sekunden für die Synchronisierung des LDAP Benutzerverzeichnis-Caches fest. [Standard: 3600]
* Beispiel:
```
  "registryConfig": {
    "jira": {
      "ldap/sync_interval": "600"
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
