## Wie man ein CES-Image erstellt
## Anforderungen
* `git` installiert
* `packer` installiert (siehe [packer.io](https://www.packer.io/))
* `VirtualBox`, `QEMU` und/oder `VMware` installiert

## 1. Schauen Sie sich das Ökosystem-Repository an
* `git clone https://github.com/cloudogu/ecosystem.git`
## 2. Bauen Sie das/die Image(s) mit Packer
* `cd <ecosystem-pfad>/images/`
* `packer build -var "timestamp=$(date +%Y%m%d)" template.prod.json`
  * Baut alle Images für die Produktion
  * Um nur einen bestimmten Build für einen der Hypervisoren zu erhalten, verwenden Sie den Parameter `--only=<Image-Typ>`. Mit ihm kann der Image-Typ auf `ecosystem-virtualbox`, `ecosystem-vmware` oder `ecosystem-qemu` konfiguriert werden
  * Der Standardbenutzer ist `ces-admin` mit dem Passwort `ces-admin` (wird im Setup-Prozess geändert)
* `packer build template.dev.json`
  * Erzeugt ein Image für die Entwicklung
  * Fügt Entwicklungswerkzeuge wie `htop` und `jq` zum vm hinzu.
    Eine vollständige Liste ist in den folgenden Dateien zu finden:
    * [dependencies.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/dependencies.sh)
    * [vagrant.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/vagrant.sh)
  * Der Standardbenutzer ist `vagrant` mit dem Passwort `vagrant`.

## 3. Warten
* Der Image-Erstellungsprozess dauert etwa 45 Minuten, abhängig von Ihrer Hardware
## 4. Beenden
* Das/die Image(s) finden Sie in `<ecosystem-Pfad>/images/output-*`.
