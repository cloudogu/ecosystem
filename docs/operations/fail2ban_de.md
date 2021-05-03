# fail2ban

fail2ban ist ein Tool mit dem Serverdienste vor DoS-Angriffen geschützt werden können. Das Tool wertet hierfür bestimmte
Logdateien aus und blockiert bei wiederholten, fehlgeschlagenen Versuchen für eine bestimmte, konfigurierbare Zeit die
betroffenen IP-Adressen.

## Installation

fail2ban ist in neueren Images des CES (ab 06/2021) automatisch installiert. fail2ban ist dabei für die Überprüfungen
von ssh-Verbindungen aktiviert und konfiguriert.

Der aktuelle Status von fail2ban kann mit dem Befehl ```fail2ban-client status``` abgefragt werden.

### manuelle Installation für ältere CES-Versionen

fail2ban kann für ältere Versionen des CES manuell nach installiert werden. Dies kann auf folgende Weise erfolgen:
Package-Liste aktualisieren:

```
sudo apt-get update
```

Installation durchführen:

```
sudo apt install fail2ban
```

Um eine bestimmte Version von fail2ban zu installieren, kann alternativ folgender Befehl ausgeführt werden:

```
FAIL2BAN_VERSION=0.10.2-2
apt-get -y install fail2ban=${FAIL2BAN_VERSION}
```

Die Konfiguration von fail2ban wird weiter unter in diesem Dokument beschrieben.

## Starten und Stoppen von fail2ban

fail2ban ist nach der Installation automatisch gestartet. fail2ban kann über das CLI von fail2ban gestoppt werden.

```
fail2ban-client stop
```

Mit folgendem Befehl kann fail2ban wieder gestartet werden.

```
fail2ban-client start
```

## Konfiguration

fail2ban kann für verschiedene Serverdienste konfiguriert werden. Standardmäßig ist fail2ban im CES für die Überprüfung
von ssh-Verbindungen aktiviert. Als Werte sind die Attribute `ignoreip`, `maxretry`, `findtime`, `bantime` und
der `logpath` konfiguriert.

Die Attribute haben folgende Bedeutung:

* `ignoreip`: Liste von IP-Adressen, die ignoriert werden sollen
* `maxretry`: legt die Anzahl der Fehlversuche fest, bevor der Host gesperrt wird
* `findtime`: legt die Anzahl der Sekunden fest, für die der Filter nach Fehlversuchen zurücksucht
* `bantime`: legt die Anzahl der Sekunden fest, für die ein Host für gesperrt wird
* `logpath`: fügt eine bestimmte Logdatei zur Überwachungsliste von hinzu

Die Konfiguration erfolgt dabei jeweils separat für einen Serverdienst.

### Manuelle Konfiguration

fail2ban bringt einen Kommandozeilen-Client mit, über den diverse Aktionen mit fail2ban möglich sind. Über diesen Client
kann die Konfiguration von fail2ban erstellt und angepasst werden.

Die grundsätzliche Überprüfung von ssh-Verbindungen kann über folgenden Befehl aktiviert werden:

```
fail2ban-client start sshd
```

Über den Client kann dann auch eine entsprechende Konfiguration zur Überprüfung eingestellt werden:

```
fail2ban-client set sshd addignoreip 127.0.0.1/8
fail2ban-client set sshd maxretry 5
fail2ban-client set sshd findtime 10m
fail2ban-client set sshd bantime 10m
fail2ban-client set sshd addlogpath /var/log/auth.log
```

Eine vollständige Referenz mit allen Befehlen des fail2ban-Clients ist auf der offiziellen Seite von fail2ban
unter https://www.fail2ban.org/wiki/index.php/Commands zu finden. Die Kommando-Referenz kann ebenfalls mit dem
Befehl ```fail2ban-client -h``` abgefragt werden.

## Log-Datei von fail2ban

Für Auswertungen und Analysen protokolliert fail2ban sämtliche durchgeführten Aktionen in einer separaten Log-Datei.
Diese Log-Datei ist unter `/var/log/fail2ban.log`zu finden. 
