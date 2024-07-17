# Wie man ein CES-Image erstellt
## Anforderungen
* `git` installiert
* `packer` installiert (siehe [packer.io](https://www.packer.io/))
* `VirtualBox`, `QEMU` und/oder `VMware` installiert

## 1. Schauen Sie sich das ecosystem-Repository an
* `git clone https://github.com/cloudogu/ecosystem.git`
## 2. Bauen Sie das/die Image(s) mit Packer
* `cd <ecosystem-pfad>/images/prod/`
* `packer build -var "timestamp=$(date +%Y%m%d)" prod.pkr.hcl`
  * Baut alle Images für die Produktion
  * Um nur einen bestimmten Build für einen der Hypervisoren zu erhalten, verwenden Sie den Parameter `--only=<Image-Typ>`. Mit ihm kann der Image-Typ auf `virtualbox-iso.ecosystem-virtualbox`, `qemu.ecosystem-qemu` oder `vmware-iso.ecosystem-vmware` konfiguriert werden
  * Der Standardbenutzer ist `ces-admin` mit dem Passwort `ces-admin` (wird im Setup-Prozess geändert)
* `cd <ecosystem-pfad>/images/dev/ && packer build dev.pkr.hcl`
  * Erzeugt ein Image für die Entwicklung
  * Fügt Entwicklungswerkzeuge wie `htop` und `jq` zur VM hinzu.
    Eine vollständige Liste ist in den folgenden Dateien zu finden:
    * [dependencies.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/dependencies.sh)
    * [vagrant.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/vagrant.sh)
  * Der Standardbenutzer ist `vagrant` mit dem Passwort `vagrant`.
* Sollte eine VirtualBox-Version kleiner als 7 zum Bauen benutzt werden, muss der zusätzliche Parameter `virtualbox-version-lower-7` benutzt werden, bspw. so: `packer build -var virtualbox-version-lower-7=true dev.pkr.hcl`

## 3. Warten
* Der Image-Erstellungsprozess dauert etwa 20 Minuten, abhängig von Ihrer Hardware und der Geschwindigkeit ihres Internetanschlusses.

## 4. Beenden
* Das/die Image(s) finden Sie in `<ecosystem-Pfad>/images/dev/build` bzw. `<ecosystem-Pfad>/images/prod/output-*`.
