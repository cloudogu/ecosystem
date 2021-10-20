# Etcd-Registy-Struktur

Die Konfiguration und Ausführung des Cloudogu EcoSystem (CES) basiert auf einer [etcd](https://coreos.com/etcd/)-Registry. Sie enthält Schlüssel-Wert-Paare, die mit dem Befehl `etcdctl ls` aufgelistet werden können. Die Schlüssel-Wert-Paare werden von den CES-Tools und Dogus verändert und sollten nicht manuell geändert werden, es sei denn, Sie wissen genau, was Sie tun!

## Details zur Registry-Struktur

### /docker

Dieser Pfad wird von Docker verwendet, um Betriebseigenschaften zu speichern. Die hier gespeicherten Schlüssel sollten niemals manuell geändert werden.

### /config

In diesem Pfad werden die Konfiguration aller installierten Docker und die globale Konfiguration gespeichert.

#### /config/_global

Dieser Pfad enthält Konfigurationen, die von mehreren Tools im CES verwendet werden, z. B. den FQDN, die Domain, die CES-Administrationsgruppe, den Standard-Dogu und Zertifikate.

Einige der wichtigsten Pfade sind:

- /config/_global/key_provider
- /config/_global/fqdn
- /config/_global/domain
- /config/_global/certificate
- /config/_global/admin_group
- /config/_global/default_dogu

#### /config/DOGUNAME

In Pfaden wie "/config/jenkins" wird die dogu-spezifische Konfiguration gespeichert.

Ein Schlüssel, der immer vorhanden ist, ist "/config/DOGUNAME/public.pem", der den öffentlichen Schlüssel zur Verschlüsselung von Daten enthält, die nur von der dogu selbst lesbar sein sollen.

Die Anzahl der anderen Konfigurationsschlüssel variiert stark zwischen den Dogus. Der Großteil ihres Zwecks ist in der zugehörigen dogu.json beschrieben.

Wenn eine manuelle Änderung der dogu-Konfigurationsschlüssel erforderlich ist, kann dies bequem über den Befehl `cesapp edit-config DOGUNAME` erfolgen.

### /dogu

Dieser Pfad enthält technische Informationen über den dogus. In Schlüsseln wie "/dogu/sonar/6.7.6-1" werden die Informationen der dogu.json im JSON-Format gespeichert.

Die hier gespeicherten Schlüssel werden automatisch erstellt, wenn ein dogu installiert wird, und sollten niemals manuell geändert werden.

### /state

Die hier gespeicherten Schlüssel (z. B. "/state/jenkins") enthalten Informationen über den Ausführungsstatus des dogus. Ihre Werte werden aus dem Dogus heraus mit dem Befehl "doguctl state" gesetzt. Sie sind Teil eines Gesundheitschecks, der durch Setzen von "Type" deklariert werden kann: "state" innerhalb des "HealthChecks"-Objekts einer dogu.json.

Die Zustandsschlüssel werden verwendet, wenn ein Gesundheitscheck für eine dogu über den Befehl "cesapp healthy DOGUNAME" durchgeführt wird. Wenn der entsprechende "/state/DOGUNAME"-Schlüssel die Zeichenkette "ready" enthält, ist der Gesundheitscheck erfolgreich.

### /services


## Aktualisierung von Zertifikaten

Wenn Sie das Zertifikat bzw. die Zertifikatskette Ihres EcoSystems aktualisieren möchten, gehen Sie bitte wie folgt vor:

### Selbstsignierte Zertifikate

- Führen Sie das Skript `/usr/local/bin/ssl.sh` aus, z.B. über `sudo /usr/local/bin/ssl.sh`.
- Starten Sie Ihr EcoSystem neu

### Externe Zertifikate
- Externe Schlüssel und Zertifikate müssen im PEM-Format vorliegen
- Speichern Sie den privaten Schlüssel Ihres Zertifikats im etcd-Key `/config/_global/certificate/server.key`, z.B. über `cat private_key.pem | etcdctl set /config/_global/certificate/server.key`
- Speichern Sie das Zertifikat bzw. die Zertifikatskette im etcd-Key `/config/_global/certificate/server.crt`.
   - Wenn Sie nur ein Zertifikat importieren wollen, tun Sie dies über `cat certificate.pem | etcdctl set /config/_global/certificate/server.crt`
   - Wenn Sie eine Zertifikatskette importieren wollen, achten Sie bitte darauf, dass alle Zertifikate (Instanz, Zwischenzertifikate) in der richtigen Reihenfolge vorliegen: Zuerst das Instanzzertifikat, dann das/die Zwischenzertifikat(e).
- Starten Sie Ihr EcoSystem neu
