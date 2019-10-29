## Beschränkung von Login-Versuchen

Login-Versuche können beschränkt werden, indem Benutzerkonten nach einer gewissen Anzahl an fehlgeschlagenen
Anmeldeversuchen innerhalb bestimmter Zeitgrenzen temporär gesperrt werden können. Ist ein Konto gesperrt, wird
der Benutzer auf eine entsprechende Seite umgeleitet. Hierbei wird nicht geprüft, ob ein Benutzerkonto existiert
(d. h. auch für nicht existierende Konten wird die Sperre durchgeführt).

Hierzu werden die folgenden Konfigurations-Parameter des CAS-Moduls genutzt:

* `login.limit.maxNumber` Setzt die maximal erlaubte Anzahl an Fehlversuchen pro Benutzerkonto.
  Wird diese Anzahl innerhalb der mit den weiteren Parametern definierten zeitlichen Rahmen
  überschritten, wird das Konto temporär gesperrt.

  Wird der Wert auf `0` gesetzt, ist das Feature deaktiviert und es findet keine Limitierung statt.
  Bei einem Wert größer Null müssen die anderen Parameter auf sinnvolle Werte gesetzt werden. 
* `login.limit.failureStoreTime` Spezifiziert die Zeitdauer, für die die Anzahl der Fehlschläge seit dem letzten
  fehlgeschlagenen Anmeldeversuch gespeichert werden soll. Wird diese Zeit zwischen zwei Anmeldeversuchen überschritten,
  werden die Fehlschläge zurückgesetzt.

  Die Zeit wird in Sekunden angegeben und muss größer Null sein, wenn das Feature aktiviert ist.
* `login.limit.lockTime` Gibt an, wie lange das Konto im Falle einer Überschreitung der Anmeldeversuche gesperrt werden
  soll.

  Die Zeit wird in Sekunden angegeben und muss größer Null sein, wenn das Feature aktiviert ist.
