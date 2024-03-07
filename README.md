# RDF-Import für NFDI4Objects

Dieses Repository enthält experimentelle Skripte zum Import von RDF-Daten in
den Knowledge-Graphen von NFDI4Objects.

## Installation

Benötigt werden Standard-Kommandozeilenwerkzeuge und

- rapper
- jq

## Benutzung

Das Skript `receive.sh` erwartet eine RDF/Turtle-Datei und eine Sammlungs-ID.

In `n4o-collections.csv` stehen bekannte Sammlungen, deren Daten übernommen
werden können und die dazu gehörige übergeordnete Datenbank aus
<https://nfdi4objects.github.io/n4o-databases/>.

Die empfangenen RDF-Daten werden syntaktisch geprüft und rudimentär bereinigt
im Verzeichnis `import` abgelegt (Datei `clean.nt`).
