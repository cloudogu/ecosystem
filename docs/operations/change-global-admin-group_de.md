# Besonderheiten bei der Änderung der globalen Admin-Gruppe

Das Cloudogu EcoSystem (CES) bietet werkseitig eine Admin-Gruppe, der Benutzerkonten zugeordnet sind, die diese CES-Instanz administrieren. Der Name dieser Admingruppe lässt sich zwar umbenennen, jedoch nur mit bestimmten Vorkehrungen.

Durch die Änderung der globalen Admin-Gruppe müssen auch die Admin-Gruppen in allen Dogus aktualisiert werden. Wie diese Änderung durchgeführt und was dabei zu beachten ist, wird in diesem Dokument näher erläutert.

## Eintrag in Registry ändern
Mit dem Befehl:
```
etcdctl set /config/_global/admin_group "<neuer Name>"
```
kann der Admin-Gruppen-Name in der Registry geändert werden. Im Anschluss wird bei erfolgreicher Änderung der neue Wert ausgegeben. 
Zusätzlich kann die Änderung auch mit folgendem Befehl überprüft werden:
```
etcdctl get /config/_global/admin_group
```
Als Ausgabe erhält man den Namen der Admin-Gruppe.

Nötige Arbeitsschritte für die Änderung der Admin-Gruppe:
```
1. Neue Admingruppe anlegen (sofern nicht vorhanden)
2. Admin-Gruppe mit Benutzerkonten anreichern
3. Admin-Gruppe in Registry ändern
4. Dogu(s) neustarten
```

## Dogu-spezifische Merkmale
Die verschiedenen Dogus gehen unterschiedlich mit der Admin-Gruppen-Änderung um. Nachfolgend werden die Eigenheiten erläutert.

### SonarQube `(ab Dogu-Version 6.7.7-2)`
SonarQube legt im Script `startup.sh` die entsprechende Admin-Gruppe an und verleiht dieser die nötigen Berechtigungen. Zusätzlich wird auch die aktuelle Admin-Gruppe in der Dogu-Konfiguration innerhalb der Registry unter dem Pfad `/config/sonar/admin_group_last` hinterlegt.
> **Der Wert von `/config/sonar/admin_group_last` darf niemals manuell angepasst werden.** (siehe Punkt `Sonderfall`)

Bei einem Neustart des Sonar-Dogus wird geprüft, ob sich die globale und die für Sonar hinterlegte Admin-Gruppe unterscheiden.

Dabei können folgende Fälle auftreten:.

1. Es gibt keinen Unterschied und das Dogu startet wie gewohnt.
    1. Bei dem ersten Dogu-Start wird entsprechend die Admin-Gruppe angelegt. Bei einem Neustart bleibt diese Gruppe unverändert bestehen.
2. Die Namen der Admin-Gruppen unterscheiden sich
    1. Die neue Gruppe wird angelegt und erhält die nötigen Rechte.
    2. Der zuletzt vom Dogu verwendeten Admin-Gruppe werden alle administrativen Berechtigungen entzogen. Die Gruppe bleibt aber weiterhin bestehen.

#### Sonderfall
Durch die manuelle Änderung des Konfigurationseintrags `/config/sonar/admin_group_last` kann dieser den Namen einer nicht vorhandenen Admin-Gruppe enthalten.

Anschließend steckt Sonar in einer endlosen Neustart-Schleife fest. Das Dogu ist somit nicht nutzbar.
Zur Lösung des Problems reicht es aus, mit:
```
etcdctl set /config/sonar/admin_group_last "<Name>"
```
einen gültigen Wert zu setzen. Alternativ kann der Eintrag mit folgendem Befehl auch komplett entfernt werden.
```
etcdctl rm /config/sonar/admin_group_last
```


### Sonatype Nexus `(ab Dogu-Version 3.18.1-01-1)`

*Der allgemeine Ablauf der Admingruppenmigration entspricht dem von SonarQube.*

Nexus legt im Script `startup.sh` die entsprechende Admin-Gruppe an und verleiht dieser die nötigen Berechtigungen. Zusätzlich wird auch die aktuelle Admin-Gruppe in der Dogu-Konfiguration innerhalb der Registry unter dem Pfad `/config/nexus/admin_group_last` hinterlegt.

Wird der Wert von `/config/nexus/admin_group_last` manuell geändert, wird der Migrationsprozess wieder gestartet, was darin resultiert, dass die aktuelle Admingruppe erneut Adminrechte erhält, der manuell eingetragenen Gruppe unter `[...]/admin_group_last` erneut Adminrechte entzogen werden und der Konfigurationswert mit der aktuellen Admingruppe überschrieben wird.
