# Upgrade von Ubuntu 20.04 auf 24.04

## 1. Upgrade von Ubuntu 20.04 auf 24.04

Sie können die Ubuntu-Distribution, auf der das Cloudogu EcoSystem aufgebaut ist, wie jedes andere Ubuntu-basierte System aktualisieren.

## 2. Anpassen der apt-Konfiguration

Nachdem Sie Ihr EcoSystem auf Ubuntu 24.04 aktualisiert haben, müssen Sie einige der EcoSystem-spezifischen apt-Konfiguration anpassen:

- Passen Sie die Datei `/etc/apt/sources.list.d/docker.list` von 20.04 (focal) auf 24.04 (noble) an
   - Fügen Sie diese Zeile ein: `deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable`
   - Entfernen Sie alte Zeilen wie `deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable`

- Passen Sie die Datei `/etc/apt/sources.list.d/hashicorp.list` von 20.04 (focal) auf 24.04 (noble) an
   - Fügen Sie diese Zeile ein: `deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main`
   - Entfernen Sie alte Zeilen wie `deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com focal main`

- Überprüfen Sie Ihre Arbeit, indem Sie `sudo apt update` ausführen. Es sollte keine Fehler melden.

## 3. Docker aktualisieren

Stellen Sie sicher, dass Sie mindestens Docker 20.10 installiert haben, z.B. über `sudo docker info | grep Server\ Version`.
Wenn Sie noch Docker 19.03 (oder älter) verwenden, sollten Sie ein Upgrade durchführen, z. B. über `sudo apt update && sudo apt upgrade`.
