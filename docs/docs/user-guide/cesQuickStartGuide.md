---
layout: ecosystem/quickStartGuide
metadata: true
lang: de
ref: ces-quickstart
section: services
switcher: true
summary: "Quickstartguide für das Cloudogu EcoSystem: VirtualBox Import, Registrierung, Konfigration und Setup."
description: "Quickstartguide für das Cloudogu EcoSystem: VirtualBox Import, Registrierung, Konfigration und Setup."
cardsimage: /images/cesQuickStartGuide/image9.png
twittervideo: true
cardsvideo: https://youtu.be/ep3bqSHwI-w
title: "Cloudogu EcoSystem Quickstartguide"
permalink: /de/ecosystem/ces-quick-start-guide/
last_modified_at: '2020-07-30 10:00:00 +0200'
crumbcategory: "ecosystem"
crumbtitle: "Quickstart Guide"
---

<img class="icon" alt="Durchstarten mit dem EcoSystem" src="images/cesQuickStartGuide/quickstart.png" />

# Cloudogu EcoSystem via VirtualBox installieren

Hallo und vielen Dank für Ihr Interesse an unserem [Cloudogu EcoSystem](/de/ecosystem ). Sollten Sie Anregungen oder Fragen haben, kontaktieren Sie uns gerne via <a title="E-Mail an Cloudogu senden" href="mailto:hello@cloudogu.com?subject=Hello%20Cloudogu">hello@cloudogu.com</a> oder telefonisch unter <a title="Cloudogu anrufen" href="tel:+4953161808880">+49. 531. 61 80 88 80</a>.

## Wie erhalten Sie Ihr Image?

Der einfachste Weg zu einem Cloudogu EcoSystem (CES) ist ein Download des VirtualBox Images über die myCloudogu Plattform.
Für den Download benötigen Sie lediglich einen kostenlosen Account, der anschließend auch für die Registrierung der Instanz während der Installation genutzt werden kann.

<a class="button" href="https://files.cloudogu.com/file/ces-images/CloudoguEcoSystem-20210203.tar.gz" target="_blank" rel="noreferrer" title="Zum Download auf myCloudogu">CES herunterladen</a>

Zur Verifizierung des Images können Sie noch den SHA256-Hash des Images <a target="_blank" title="CES Download SHA256-Hash" href="https://files.cloudogu.com/file/ces-images/SHA256SUMS">herunterladen</a>.

---

## Vorbereitungen

Um mit dem [Cloudogu EcoSystem](/de/ecosystem ) zu starten,  benötigen Sie eine Virtualisierungsumgebung um die Plattform zu betreiben. Idealerweise besitzen Sie eine leistungsstarke lokale Maschine oder verfügen über bereitgestellte Hardware in einem Rechenzentrum.

Ihr Hoster hält vermutlich eine Anleitung bereit, wie Sie Images von Dritten in Ihr System laden und verwenden können.
Sollten Sie das Image nicht in einer Serverumgebung betreiben, empfehlen wir die aktuelle Version der <a target="_blank" rel="noreferrer" title="VirtualBox Wiki" href="https://www.virtualbox.org/wiki/Downloads">VirtualBox</a>.

### Die Einrichtung in der VirtualBox

Über den Reiter „Importieren“ auf der Startseite des Programms bekommen Sie ein Kontextmenü angezeigt. Hier muss der „Expertenmodus“ ausgewählt werden, um die Option „Zuweisen neuer MAC-Adressen für alle Netzwerkkarten“ nutzen zu können.

<a data-lightbox="Quickstart Guide" data-title="Import der Maschine" class="lightbox-img" href="/images/cesQuickStartGuide/image2.png"><img alt="Import der Maschine" src="images/cesQuickStartGuide/image2.png"></a>

Nachdem Sie das heruntergeladene Image angegeben und ggf. Anpassungen durchgeführt haben, können Sie den Import starten.

<a data-lightbox="Quickstart Guide" data-title="Import der Maschine" class="lightbox-img" href="/images/cesQuickStartGuide/image12.png"><img alt="Import der Maschine" src="images/cesQuickStartGuide/image12.png"></a>

Nach einem erfolgreichen Import können Sie die Maschine hochfahren. **Wichtig:** Stellen Sie den Netzwerkadapter der Maschine auf `Netzwerkbrücke`.

<a data-lightbox="Quickstart Guide" data-title="Maschinenstatus" class="lightbox-img" href="/images/cesQuickStartGuide/image16.png"><img alt="Maschinenstatus" src="images/cesQuickStartGuide/image16.png"></a>

### Die Einrichtung bei einem Hoster

Zum Importieren des Images bei Ihrem Hoster konsultieren Sie bitte dessen FAQ. Das Dateiformat könnte hierbei abweichen. Falls Sie das Image konvertieren müssen, können wir eine korrekte Funktionsfähigkeit nicht garantieren. Weitere Formate können bei uns angefragt werden.

---

## Durchführen des Setups

### Registrierung (CES Instance Registration)

Die Registrierung der Instanz ist notwendig um Zugriff auf die von uns bereitgestellten Dogus zu erhalten. Ihre erste Instanz ist gänzlich kostenfrei. Bei Fragen können Sie sich jederzeit an uns wenden. Sollten Sie Bedarfe haben die mit unserem Community Angebot nicht gedeckt sind, bieten wir Ihnen maßgeschneiderte Kooperationsverträge an. Hierzu zählt auch die Implementierung von weiteren Dogus, die Ihre Bedürfnisse komplettieren.


* <a target="_self" title="Informationen zu unseren Dogus" href="/de/glossar/dogu">Informationen zu unseren Dogus</a>

* <a target="_self" title="Informationen zu möglichen Instanzen" href="/de/ecosystem/#pricing">Informationen zu möglichen Instanzen</a>

* <a target="_self" title="Datenschutzerklärung" href="/de/privacy/">Datenschutzerklärung</a>

Die Maschine steht Ihnen in der Regel über die Website `http://192.168.0.56:8080` für das Setup zur Verfügung. Sollte dies nicht der Fall sein, wurde der Maschine von Ihrem Netzwerk eine andere IP zugewiesen. Um die IP herauszufinden müssen Sie sich über das CLI anmelden. Die Logindaten sind Username `ces-admin` mit dem Passwort `ces-admin`. **Hinweis:** Das Standard-Keyboard-Layout ist Englisch, das "-" ist auf der "ß" -Taste. **Wichtig:** Das Passwort des Users ces-admin wird am Ende des Setup-Prozesses durch eine zufällig generierte Zeichenfolge ersetzt, die Ihnen dann mitgeteilt wird.

<a data-lightbox="Quickstart Guide" data-title="IP Adresse" class="lightbox-img" href="/images/cesQuickStartGuide/ip_address.png"><img alt="IP Adresse" src="images/cesQuickStartGuide/ip_address.png"></a>

Nach dem erfolgreichen Login wird die IP der Maschine angezeigt. Sie können das Setup unter `http://ip-adresse:8080` starten.

<a data-lightbox="Quickstart Guide" data-title="Registration" class="lightbox-img" href="/images/cesQuickStartGuide/image9.png"><img alt="Registration" src="images/cesQuickStartGuide/image9.png"></a>

Dort können Sie den Prozess mit „Register instance“ starten.

<a data-lightbox="Quickstart Guide" data-title="Login" class="lightbox-img" href="/images/cesQuickStartGuide/image10.png"><img alt="Login" src="images/cesQuickStartGuide/image10.png"></a>

Um Ihre Instanz zu registrieren, können Sie Ihren myCloudogu Account nutzen. Alternativ können Sie sich auch mit einem GitHub- oder Google-Account anmelden oder einen neuen Account registrieren.

<a data-lightbox="Quickstart Guide" data-title="Abschließen der Registrierung" class="lightbox-img" href="/images/cesQuickStartGuide/image11.png"><img alt="Abschließen der Registrierung" src="images/cesQuickStartGuide/image11.png"></a>

Bestätigen Sie anschließend die Registrierung Ihrer Instanz unter Ihrem Account.

<a data-lightbox="Quickstart Guide" data-title="Erfolgreiche Registrierung" class="lightbox-img" href="/images/cesQuickStartGuide/image8.png"><img alt="Erfolgreiche Registrierung" src="images/cesQuickStartGuide/image8.png"></a>

### Region (Set region specific settings)

Nach der Registrierung beginnt die Konfiguration Ihrer Instanz. Der erste Schritt ist die Festlegung der Region Ihrer Instanz.

<a data-lightbox="Quickstart Guide" data-title="Region Einstellungen" class="lightbox-img" href="/images/cesQuickStartGuide/image7.png"><img alt="Region Einstellungen" src="images/cesQuickStartGuide/image7.png"></a>

### Naming (FQDN, Hostname, Domain and Certificates)

Im nächsten Schritt werden Informationen zur Erreichbarkeit Ihrer Instanz und dem E-Mail-Versand benötigt.

<a data-lightbox="Quickstart Guide" data-title="Naming" class="lightbox-img" href="/images/cesQuickStartGuide/image6.png"><img alt="Naming" src="images/cesQuickStartGuide/image6.png"></a>

**Hinweis FQDN:** Die „FQDN“ zeigt standardmäßig die IP-Adresse des virtuellen Systems an. Sie können die „FQDN“ auch ändern, indem Sie z.B. eine firmeneigene URL eintragen. Empfehlenswert ist eine Zusammensetzung aus „Hostname“ und „Domain“. Wenn kein FQDN angegeben wird, ist das CES nur über die IP erreichbar.

**Hinweis Certificate Type:** Wenn Sie noch keine Zertifikate für Ihre Instanz haben, können Sie „Self Signed“ auswählen. Für einen produktiven Betrieb empfehlen wir jedoch, dass Sie Third Party Zertifikate benutzen.

**Hinweis Mail Relay Host:** Nur wenn ein gültiger Mailserver angegeben ist kann das Cloudogu EcoSystem E-Mails verschicken. Der Mail Relay Host kann sowohl als URL als auch als IP-Adresse angegeben werden. Auch ein inkorrekter Mail Relay Host, bspw. für Testzwecke, ist möglich.



### User Backend (Configure your directory service)

Wählen Sie bitte die gewünschte Nutzerverwaltungsdatenbank. Wir liefern Ihnen eine implementierte Version direkt mit. Sollten Sie bereits ein eigenes LDAP oder Active Directory zur Verfügung haben, können Sie dieses selbstverständlich anbinden und konfigurieren.

<a data-lightbox="Quickstart Guide" data-title="User Backend" class="lightbox-img" href="/images/cesQuickStartGuide/image5.png"><img alt="User Backend" src="images/cesQuickStartGuide/image5.png"></a>

### Dogu (Choose your Dogus)

Suchen Sie Ihre Werkzeuge (Dogus) aus und legen Sie ein Dogu als Startseite nach dem Login (Default Dogu) fest.

<a data-lightbox="Quickstart Guide" data-title="Dogu Auswahl" class="lightbox-img" href="/images/cesQuickStartGuide/image4.png"><img alt="Dogu Auswahl" src="images/cesQuickStartGuide/image4.png"></a>

Details zu den Dogus finden Sie in unserem <a target="_self" title="Dogus – Cloudogu Glossar" href="/de/glossar/dogu">Glossar</a>.

**Hinweis:** Abhängigkeiten zwischen Dogus werden automatisch berücksichtigt. Wenn Sie also z.B. „Jenkins CI“ auswählen, werden automatisch auch „Central Authentication Service“, „Nginx“, „Postfix“ und „Registrator“ ausgewählt, da diese für den Betrieb von Jenkins benötigt werden.

In dem Default Dogu Feld können Sie auswählen welches Dogu nach dem Login an Ihrem Cloudogu EcoSystem als erstes angezeigt werden soll. Diese Einstellung gilt für alle Nutzer der Plattform.

**Hinweis:** Für die Community Edition des Cloudogu EcoSystem stehen keine Premium Dogus, wie z.B. „Backup & Restore“ zur Verfügung.

### Admin (Configure the Administrator)
Im letzten Schritt der Konfiguration legen Sie den ersten User Ihres Cloudogu EcoSystem und einen Gruppennamen für Administratoren fest.

<a data-lightbox="Quickstart Guide" data-title="Administrator Konfiguration" class="lightbox-img" href="/images/cesQuickStartGuide/image17.png"><img alt="Administrator Konfiguration" src="images/cesQuickStartGuide/image17.png"></a>

**Hinweis:** Die Administratorengruppe (Admin Group) ist eine voreingestellte Gruppe des eingebetteten Directory Service, welche den Mitgliedern Administrationszugriff auf die installierten Tools gibt.

Um Ihren User auch als Administrator in den Dogus zu berechtigen, wählen Sie die Checkbox „Configure the user also as tool administrator“ aus.

**Hinweis:** Sollten Sie dem ersten User keine Administratorrechte geben, hat der User trotzdem die Rechte um weitere Benutzer in dem eingebetteten Directory Service anzulegen und Administratorrechte zu vergeben.

Wenn Sie einen gültigen Mail Relay Host angegeben haben, können Sie optional die automatisch generierten UNIX-Zugangsdaten an die hinterlegte E-Mail-Adresse senden lassen. Unabhängig davon werden diese nach Abschluss der Installation einmalig angezeigt.

### Setup

In der letzten Phase sehen Sie, wie die Installation mit der von Ihnen vorgenommen Konfiguration Schritt für Schritt  abgearbeitet wird.

<a data-lightbox="Quickstart Guide" data-title="Setupprozess" class="lightbox-img" href="/images/cesQuickStartGuide/image18.png"><img alt="Setupprozess" src="images/cesQuickStartGuide/image18.png"></a>

Nach Vollendung des Setup-Prozesses werden Ihnen einmalig Ihre UNIX-Zugangsdaten angezeigt. **Sichern Sie sich diese Daten sorgfältig.**

<a data-lightbox="Quickstart Guide" data-title="Zugangsdaten" class="lightbox-img" href="/images/cesQuickStartGuide/image19.png"><img alt="Zugangsdaten" src="images/cesQuickStartGuide/image19.png"></a>

Sie können über den angebotenen Link direkt ins Cloudogu EcoSystem navigieren. Je nachdem wie performant ihre Maschine ist, kann es einige Minuten dauern bis alle Dogus gestartet sind und Sie sich anmelden können.

Damit ist die Installation Ihres Cloudogu EcoSystem abgeschlossen. Sie können nun damit beginnen Benutzer und Daten zum System hinzuzufügen.

---

## Ein kurzer Einstieg in das Cloudogu EcoSystem

Je nachdem welche Dogus sie ausgewählt haben, steht Ihnen nun eine umfangreiche Auswahl an unterschiedlichen Werkzeugen zur Verfügung.

**Wichtig:** Beachten Sie den Pfeil am rechten mittleren Bildschirmrand. Mit dieser Seitennavigationsleiste gelangen Sie auf die installierten Dogus.

<a data-lightbox="Quickstart Guide" data-title="CES WarpMenu" class="lightbox-img" href="/images/cesQuickStartGuide/Setup_Navigation.png"><img alt="CES WarpMenu" src="images/cesQuickStartGuide/Setup_Navigation.png"></a>
