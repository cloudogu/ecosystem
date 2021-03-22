# Automatische Sicherheitsupdates im CES

Es gibt [mehrere Möglichkeiten](https://help.ubuntu.com/community/AutomaticSecurityUpdates), automatische Sicherheitsupdates in Ubuntu zu aktivieren. Die häufigste ist die Verwendung des Pakets "unattended-upgrades". Dieses Paket installiert automatisch apt-Paketaktualisierungen, sobald sie verfügbar sind.
Da dieses Verhalten den Wunsch des Administrators, den Rechner unter Kontrolle zu haben, beeinträchtigen kann, wird das Paket "unattended-upgrades" im CES deaktiviert.

Um das "unattended-upgrades"-Paket wieder zu aktivieren und die automatischen Sicherheitsupdates im CES zu aktivieren, gehen Sie bitte wie folgt vor:

- Entfernen Sie die Datei `/etc/apt/apt.conf.d/99_disable_periodic_update`.
- Aktivieren Sie den Dienst `apt-daily.timer`:
  - `sudo systemctl enable apt-daily.timer`
  - `sudo systemctl start apt-daily.timer`
- Stellen Sie sicher, dass die Datei `/etc/apt/apt.conf.d/20auto-upgrades` den folgenden Inhalt hat:

```
APT::Periodic::Update-Package-Listen "1";
APT::Periodic::Unattended-Upgrade "1";
```

- Stellen Sie sicher, dass die folgenden Zeilen in `/etc/apt/apt.conf.d/50unattended-upgrades` nicht auskommentiert sind:

```
"${distro_id}:${distro_codename}";
"${distro_id}:${distro_codename}-security";
```

- Aktivieren Sie den Dienst "unattended-upgrades":
  - `sudo systemctl enable unattended-upgrades`
  - `sudo systemctl start unattended-upgrades`

Um zu überprüfen, ob automatische Updates aktiviert sind, führen Sie den Befehl `apt-config dump APT::Periodic::Unattended-Upgrade` aus.
Die Ausgabe sollte lauten: `APT::Periodic::Unattended-Upgrade "1";`

Übersetzt mit www.DeepL.com/Translator (kostenlose Version)