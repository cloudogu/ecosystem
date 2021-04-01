# Goss Spec

Seit Version 0.13.0 ist die cesapp in der Lage, Tests zur Verifizierung von [goss](https://github.com/aelsabbahy/goss) specs auszuführen.

## Wie man eine Goss-Spec für einen Container schreibt

Es gibt zwei Möglichkeiten, goss specs für einen dogu zu schreiben. Der harte Weg und der einfache Weg.

### Der harte Weg

* Erstellen Sie eine Datei unter `spec/goss/goss.yaml`.
* Hinzufügen von Testfällen wie in der [goss-Dokumentation](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md#available-tests) beschrieben
* Testen Sie Ihre Spezifikation mit `cesapp verify dogu-directory`.

### Der einfache Weg

* Erstellen Sie eine leere Datei unter `spec/goss/goss.yaml`.
* verifizieren Sie die Spezifikation, behalten Sie den Test-Container mit `cesapp verify dogu-directory --keep-container` und ignorieren Sie den verify-Fehler
* in den Container springen mit `docker exec -ti dogu-name bash`
* Ändern Sie das Verzeichnis in `/spec/goss`.
* nun können Sie Tests zu goss spec hinzufügen z.B.: `goss add file /etc/nginx/nginx.conf`, für eine vollständige Liste schauen Sie in die [goss documentation](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md#available-tests)

## Wie es funktioniert

* Die cesapp erstellt das Container-Image des dogu
* Der Dogu-Container wird mit Volumes für das Goss-Binär- und das Spec-Verzeichnis erstellt
* Der Container wird mit dem Goss-Binary unter `/usr/bin/goss` und dem Spec-Verzeichnis unter `/spec` gestartet.
* Die cesapp wartet, bis das Dogu gesund ist.
* Goss wird im Container mit `/spec/goss/goss.yaml` als Eingabe ausgeführt
* Der Testcontainer wird gestoppt und entfernt

## Build-Server-Integration

Der Befehl `verify` ist in der Lage, die Ergebnisse in einer Build-Server-freundlichen Weise zu speichern, z.B.: `cesapp verify dogu-directory --ci --report-directory reports`.
Der Befehl formatiert nun die Ausgabe im Junit-Format und schreibt den Bericht in die Datei `reports/goss_doguname.xml`.
