# Wie man ein Dogu erstellt

Im Folgenden finden Sie eine kurze Anleitung zum Erstellen eines Dogus. Eine ausführlichere Anleitung finden Sie in unseren [Dogu-Development-Docs auf Github](https://github.com/cloudogu/dogu-development-docs/).

## 1. Verzeichnis dogu erstellen
Erstellen Sie das Verzeichnis /ecosystem/containers/'newDoguName' und legen Sie diese grundlegenden Dateien darin ab:

* `Dockerfile` --> Erstellung des Docker-Images Ihres neuen Dogus.
* `startup.sh` --> Befehle, die bei jedem Start des Dogus ausgeführt werden
* `dogu.json` --> Wichtige Konfigurationsinformationen des Dogus.

Für zusätzliche Ressourcen der neuen dogu kann ein Ordner namens `resources` angelegt werden.
## 2. Füllen Sie die Dateien mit Inhalt
### Dockerfile
* Feste Befehle, die nur einmal ausgeführt werden müssen, sind hier enthalten
* Richtlinien zum Schreiben von Dockerfiles finden Sie [hier](https://docs.docker.com/engine/reference/builder/) und [hier](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).
* Für Java-basierte Anwendungen verwenden Sie das cloudogu `java` Base-Image
* Für andere Anwendungen verwenden Sie das cloudogu `base` Basis-Image
* Wenn Ihr Cloudogu eine Web-Anwendung ist, fügen Sie die Zeile `ENV SERVICE_TAGS webapp` hinzu. Dies führt dazu, dass Ihr dogu im Warp-Menü angezeigt wird.
* Kopieren Sie Ihre Ressourcen in das dogu, falls erforderlich.
* Fügen Sie die Information `MAINTAINER` ein

### startup.sh
* Befehle, die bei jedem Start des dogu ausgeführt werden müssen, sind hier enthalten
* Anlegen oder Ändern von Dateien und Verzeichnissen, falls erforderlich
* Befehle ausführen, die beim ersten oder bei jedem Start notwendig sind
* Fügen Sie am Ende der Datei einen Befehl zum Starten Ihrer Anwendung ein

### dogu.json
* Name: Der Name der neuen dogu
* Version: Die Version des neuen dogu
* DisplayName: Der vollständige Name der neuen Dogu
* Description: Kurze Beschreibung der Software in dieser Dogu
* Category: Die EcoSystem-Kategorie, in die Ihr Dogu passt. Mögliche Optionen sind bisher: `Development Apps`, `Administration Apps`, `Documentation` und `Base`
* Tags (JSON-Array): Ein-Wort-Tags, die mit diesem Dogu in Verbindung stehen
* Logo: Link zum Logo-Bild für diese Anwendung
* Url: Offizielle Website der Software in dieser dogu
* Image: Pfad zum Image in der Cloudogu-Registry
* ExposedCommands (JSON-Array):
* HealthChecks (JSON-Array):
* Volumes (JSON-Array): Verzeichnisse im EcoSystem, auf die auch von innerhalb des Dogus zugegriffen werden kann
* Volumes-> Volume-> NeedsBackup (bool): Indikator für das Backup. Wird auf false gesetzt, wenn Volume-Daten für das Backup nicht wichtig sind
* ServiceAccounts (JSON-Array):
* Dependencies (JSON-Array): Liste der Dogus, von denen dieses Dogu abhängt

#### dogu.json - Dependencies

Es gibt drei Möglichkeiten um Dogu-Abhängigkeiten zu definieren:

* Andere Dogus
* Pakete (bspw. backup-watcher)
* Clients (bspw. cesapp, ces-setup)

Für die ersten beiden Fälle muss sichergestellt werden, dass die Abhängigkeiten installiert sind. Die Client-Abhängigkeit gibt an, welche Version ein Client haben muss, um das Dogu richtig nutzen zu können. Der Client selbst ist aber nicht für den Betrieb des Dogus erforderlich (kann also auch nach dem Start des Dogus deinstalliert werden). Beispiel: Es ist nicht wichtig, welches ces-setup installiert ist, wenn ich nachträglich ein neues Dogu installiere.

Zu den Typen, gibt es die Möglichkeit, bestimmte Versionen anzugeben (Format: (<=,<,>,>=)2.X.X).

Beispiel-JSON:
 ```
   "Dependencies": [
     {"type":"dogu", "name":"cas", "version": ">=4.1.1-2"},
     {"type":"package", "name":"backup-watcher", "version": "<=1.0.1"},
     {"type":"client", "name":"ces-setup", "version": ">=2.0.1"},
   ]
 ```

## 3. Erstellen Sie Ihr Dogu
* Starten Sie das EcoSystem.
* Gehen Sie zu /vagrant/containers
* Tippen Sie `cesapp build 'newDoguName'`
* Wenn die dogu erfolgreich erstellt wurde, geben Sie `docker start 'newDoguName'` ein.

## 4. Testen Sie Ihr Dogu
* Prüfen Sie /var/log/docker/'newDoguName'.log, ob dogu korrekt gestartet wurde.
* Starten Sie Ihr dogu über `docker restart 'newDoguName'` neu und überprüfen Sie das Protokoll erneut
* Stellen Sie sicher, dass alle Bash-Skripte der [guideline](bash-guideline_de.md) entsprechen 
