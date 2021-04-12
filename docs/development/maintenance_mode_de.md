# Wartungsmodus

Um den CES in den Wartungsmodus zu versetzen, muss der folgende String in `/config/_global/maintenance` geschrieben werden:

```json
{
"title": "Dies ist der Titel",
"text": "Das ist der Text"
}
``` 
Jede Anfrage an den CES wird dann mit dem HTTP-Code 503 (Service Unavailable) beantwortet, bis der Schlüssel in etcd
entweder gelöscht oder auf eine leere Zeichenkette geändert wird. Änderungen am JSON in etcd werden sofort berücksichtigt.

## Vorsicht
Da die Wartungsseite von nginx bedient wird, ist es nicht möglich, die Wartungsmodus-Seite anzuzeigen, während ein Upgrade von Nginx läuft.
