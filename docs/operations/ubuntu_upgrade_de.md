# Upgrade von Ubuntu 18.04 auf 20.04

## 1. Upgrade von Ubuntu 18.04 auf 20.04

Sie können die Ubuntu-Distribution, auf der das Cloudogu EcoSystem aufgebaut ist, wie jedes andere Ubuntu-basierte System aktualisieren. Eine gute Referenz über die zu unternehmenden Schritte finden Sie hier: https://www.linuxcloudvps.com/blog/how-to-update-your-server-from-ubuntu-18-04-to-ubuntu-20-04/

## 2. Anpassen der apt-Konfiguration

Nachdem Sie Ihr EcoSystem auf Ubuntu 20.04 aktualisiert haben, müssen Sie einige der EcoSystem-spezifischen apt-Konfiguration anpassen:

- Passen Sie die Datei `/etc/apt/sources.list.d/ces.list` von 18.04 (bionic) auf 20.04 (focal) an
   - Fügen Sie diese Zeile ein: `deb [arch=amd64] https://apt.cloudogu.com/ces/ focal main`
   - Entfernen Sie alte Zeilen wie `deb [arch=amd64] https://apt.cloudogu.com/ces/ bionic main`

- Passen Sie die Datei `/etc/apt/sources.list.d/docker.list` von 18.04 (bionic) auf 20.04 (focal) an
   - Fügen Sie diese Zeile ein: `deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable`
   - Entfernen Sie alte Zeilen wie `deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable`

- Passen Sie die Datei `/etc/apt/sources.list.d/hashicorp.list` von 18.04 (bionic) auf 20.04 (focal) an
   - Fügen Sie diese Zeile ein: `deb [arch=amd64] https://apt.releases.hashicorp.com focal main`
   - Entfernen Sie alte Zeilen wie `deb [arch=amd64] https://apt.releases.hashicorp.com bionic main`

- Überprüfen Sie Ihre Arbeit, indem Sie `sudo apt update` ausführen. Es sollte keine Fehler melden.

## 3. Docker aktualisieren

Stellen Sie sicher, dass Sie mindestens Docker 20.10 installiert haben, z.B. über `sudo docker info | grep Server\ Version`.
Wenn Sie noch Docker 19.03 (oder älter) verwenden, sollten Sie ein Upgrade durchführen, z. B. über `sudo apt update && sudo apt upgrade`.
