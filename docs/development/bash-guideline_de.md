## Bash-Skript-Richtlinie

## Start with a shebang
Die erste Zeile in einem Bash-Skript sollte

    #!/bin/bash

## Beschreibung hinzufügen
Fügen Sie am Anfang des Skripts eine Beschreibung ein, wenn der Zweck des Skripts durch seinen Namen o.ä. nicht ganz klar ist.

## Verwenden Sie die folgenden set-Zeilen, damit Ihr Skript bei Fehlern beendet wird, anstatt sie zu ignorieren:

    set -o errexit
Weist die Bash an, sich sofort zu beenden, wenn ein Befehl einen Exit-Status ungleich Null hat. Sie können '|| true' an Befehle anhängen, die fehlschlagen dürfen/einen Exit-Code ungleich Null haben.

    set -o nounset
Wenn diese Option gesetzt ist, ist ein Verweis auf eine Variable, die Sie vorher nicht definiert haben - mit Ausnahme von $* und $@ - ein Fehler und führt zum sofortigen Beenden des Programms.

    set -o pipefail
Diese Einstellung verhindert, dass Fehler in einer Pipeline maskiert werden. Wenn ein Befehl in einer Pipeline fehlschlägt, wird dieser Rückgabecode als Rückgabecode der gesamten Pipeline verwendet.

## Fehlerinformationen nach stderr schreiben
Schreiben Sie alle Fehlerdaten nach stderr, indem Sie

    >&2
vor oder nach 'echo'-Befehlen einfügen.

## Variablen mit ${} verwenden
Wenn Sie auf Variablen verweisen, verwenden Sie geschweifte Klammern anstelle von einfach $VARIABLE.

## Automatisieren Sie apt-get
Die folgenden Zeilen sind nützlich, wenn Software automatisch mit apt-get installiert wird:

    apt-get --assume-yes (oder -y) ...
Automatische 'ja'-Antwort auf Fragen von apt-get

    DEBIAN_FRONTEND=noninteractive apt-get ...
Sorgt dafür, dass das Frontend überhaupt nicht mit Ihnen interagiert und dass die Standardantworten für alle Fragen verwendet werden.

## Temporäre Daten entfernen
Nachdem Sie die Installationsdaten an einen temporären Ort kopiert und ausgeführt haben, vergessen Sie nicht, diese zu entfernen, wenn Ihre Installation erfolgreich war.

## Weitere Informationen:

[Inoffizielle Bash Strict Mode Beschreibung](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

[Best Practices für das Schreiben von Bash-Skripten](http://kvz.io/blog/2013/11/21/bash-best-practices/)
