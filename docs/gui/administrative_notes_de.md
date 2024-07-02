# Administrationshinweise

## Berechtigungen neuer Nutzer im User Management
### Gruppen
Ein neu angelegter Benutzer hat keine ihm zugewiesenen Gruppen. Grundsätzlich sind immer zwei Gruppen verfügbar,
welche einem Nutzer zugewiesen werden können. Die "cesManager"-Gruppe und die "cesAdmin"-Gruppe. Desweiteren
können im User Management unter dem Reiter "Gruppen" weitere Gruppen hinzugefügt und den Benutzern zugewiesen
werden. Diese Gruppen werden auf die einzelnen Dogus übertragen und können dort berechtigt werden. 

Weitere Informationen zum Rechtemanagement finden Sie [hier](https://docs.cloudogu.com/de/usermanual/usermgt/documentation/#rechtekonzept-im-cloudogu-ecosystem).

#### cesManager Gruppe
Ein Nutzer in der cesManager Gruppe hat Zugriff auf die Administrativen Dogus, wie zum Beispiel das Backup & Restore Dogu.

#### cesAdmin Gruppe
Der Name dieser Gruppe wird beim CES-Setup ausgewählt und kann daher variieren. Nutzer in dieser Gruppe bekommen alle
administrativen Berechtigungen in sämtlichen Dogus.

## Häufig auftretende Probleme
### Manuell angelegte Nutzer und Gruppen
In einigen Dogus führt es zu Problemen, wenn ein Nutzer im Dogu angelegt wird. Grundsätzlich muss ein Nutzer im User Management angelegt werden, damit dieser sich in allen Dogus anmelden kann.
Einige Dogus unterstützen zusätzlich das manuelle Anlegen von Nutzern, in anderen kann es aber zu Problemen führen.

Sollte es in einem Dogu nicht möglich sein, dass sich ein bestimmter Nutzer, welcher im User Management bereits angelegt wurde, im Dogu anmelden kann, kann die Ursache dafür sein, dass der Nutzer manuell im Dogu angelegt wurde.

Sollte das der Fall sein, muss der Nutzer in diesem Dogu gelöscht werden. Der Nutzer wird dann automatisch mit dem Dogu synchronisiert, sobald er sich das erste Mal einloggt.

Dasselbe gilt für Gruppen, die manuell angelegt wurden. Sollte es dabei zu Problemen führen, müssen diese im Dogu ebenfalls gelöscht werden.

### Änderung von Benutzerdaten

Sollten sich die Daten eines Nutzers verändern, wie z.B der Name, so müssen diese Änderungen im User Management erfolgen. Änderungen in den einzelnen Dogus sind unwirksam, da diese beim nächsten Login des Nutzers wieder mit denen aus dem User Management überschrieben werden.
Die Synchronisierung von Benutzerdaten findet zum Zeitpunkt des Logins in einem Dogu statt. Wird also zum Beispiel der Name eines Nutzers im User Management verändert, wird dies erst dann in einem Dogu sichtbar, wenn der Nutzer sich dort nach der Änderung eingeloggt hat.



