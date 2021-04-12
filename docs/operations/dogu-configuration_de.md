# Dogu-Konfiguration

Benutzerdefinierte Konfigurationseinstellungen werden in der Registry (etcd) des Cloudogu EcoSystems gespeichert. Es gibt zwei Schlüssel, die für ein Dogu relevant sind:

* **/config/nameOfDogu** (dogu-spezifische Einstellungen)
* **/config/_global** (globale Einstellungen)

## Verwendung

Ein dogu kann diese Einstellungen z.B. mit dem `doguctl`-Kommandozeilen-Utility abrufen:

```bash
# Lesen der Einstellung test aus /config/conf-dogu/title
doguctl config title

# lese verschlüsselte Einstellung secret aus /config/conf-dogu/secret
doguctl config -e secret

# lese globale Einstellung admin_group aus /config/_global/admin_group
doguctl config -g admin_group
```

## Validierung

Ab Version 0.14 ist die `cesapp` in der Lage, diese Einstellungen zu validieren, wenn die dogu einen Konfigurationsabschnitt in der *dogu.json* definiert, z.B.:

```json
{
  "Name": "sample/conf-dogu",
  "Version": "0.1.0",
  "DisplayName": "Conf Dogu",
  "Description": "Dogu mit Konfiguration",
  "Image": "registry.cloudogu.com/sample/conf-dogu",
  "URL": "https://cloudogu.com",
  "Configuration": [{
    "Name": "title",
    "Description": "Titel der Index-Seite"
  }, {
    "Name": "secret",
    "Description": "Verschlüsseltes Secret",
    "Encrypted": true
  }, {
    "Name": "body",
    "Description": "Inhalt der Index-Seite",
    "Optional": true
  }]
}
```

Die `cesapp` gibt einen Fehler aus, wenn eine erforderliche Einstellung in der Registry fehlt. Erforderliche Einstellungen sind alle Einstellungen, die nicht explizit als optional gekennzeichnet sind (wie title und secret im obigen Beispiel).

## Bearbeiten

Die Einstellungen einer dogu können mit dem Unterbefehl `edit-config` der `cesapp` geändert oder erstellt werden. Der Befehl kann verwendet werden mit entweder

* einem Pfad zu einer `dogu.json`
* dem Namen eines installierten dogus
* einem Remote-Namen

Beispiele:

```bash
# Einstellungen einer lokalen dogu.json bearbeiten, die sich in /vagrant/containers/conf-dogu befindet
cesapp edit-config /vagrant/containers/conf-dogu

# Einstellungen der lokalen /vagrant/containers/conf-dogu/dogu.json bearbeiten
cesapp edit-config /vagrant/containers/conf-dogu/dogu.json

# Einstellungen eines entfernten json bearbeiten
cesapp edit-config sample/conf-dogu

# Einstellungen eines installierten dogu bearbeiten
cesapp edit-config conf-dogu
```

### Entfernen einer Einstellung

Standardmäßig können Einstellungen nur geändert, aber nicht entfernt werden. Für den Fall, dass Sie eine Einstellung explizit aus der Registry entfernen wollen, muss der Unterbefehl `edit-config` mit dem `delete-on-empty` und einem leeren Wert verwendet werden.

``bash
cesapp edit-config --delete-on-empty conf-dogu
```
Wenn nun der eingegebene Konfigurationswert leer ist, wird die Einstellung aus der Registry entfernt.
