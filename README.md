# RDF-Import für NFDI4Objects

Dieses Repository enthält Skripte zur Prüfung von zu importierenden RDF-Daten
in den oder die Knowledge-Graphen von NFDI4Objects. Dies beinhaltet:

1. Die eindeutige Zuordnung von gelieferten RDF-Daten zu definierten Sammlungen
2. Die syntaktische Prüfung der RDF-Daten
3. Das Aussortieren RDF-Tripel mit relativen URIs
4. Erste Statistik und Übersicht verwendeter Properties und RDF-Namensräume zur Einschätzung der Nutzbarkeit der Daten

## Installation

Benötigt werden Standard-Kommandozeilenwerkzeuge (grep, awk, sed...) sowie

- rapper
- jq
- Python (geplant)

## Benutzung

### Annahme und Erstkontrolle der Daten

Das Skript `receive.sh` erwartet eine Sammlungs-ID und eine RDF/Turtle-Datei.

In `n4o-collections.csv` stehen bekannte Sammlungen, deren Daten übernommen
werden können und die dazu gehörige übergeordnete Datenbank aus
<https://nfdi4objects.github.io/n4o-databases/>.

Die empfangenen RDF-Daten werden syntaktisch geprüft und rudimentär bereinigt
im Verzeichnis `import` abgelegt (Datei `absolute.nt`).

Darüber hinaus wird eine Statistik der verwendeten RDF-Properties und der
RDF-Namensräume von Subjekt- und Objekt-URIs erstellt

