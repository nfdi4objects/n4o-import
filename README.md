# RDF-Import für NFDI4Objects

Dieses Repository enthält Skripte zur Prüfung von zu importierenden RDF-Daten
in den oder die Knowledge-Graphen von NFDI4Objects. Dies beinhaltet:

1. Die eindeutige Zuordnung von gelieferten RDF-Daten zu definierten Sammlungen oder Publikationen
2. Die syntaktische Prüfung der RDF-Daten
3. Aussortieren von doppelten Tripeln
4. Aussortieren RDF-Tripel mit relativen URIs
5. Erste Statistik und Übersicht verwendeter Properties und RDF-Namensräume zur Einschätzung der Nutzbarkeit der Daten

## Installation

Benötigt werden Standard-Kommandozeilenwerkzeuge (grep, awk, sed...) sowie

- rapper (`sudo apt install raptor2-utils`)
- jq (`sudo apt install jq`)
- Python 3

## Benutzung

### Annahme und Erstkontrolle der Daten

Das Skript `receive.sh` erwartet eine Sammlungs-ID und eine RDF/Turtle-Datei.

In `n4o-collections.csv` stehen bekannte Sammlungen und Datenpublikationen,
deren Daten übernommen werden können und falls vorhanden die dazu gehörige
übergeordnete Datenbank aus <https://nfdi4objects.github.io/n4o-databases/>.

**Beispiele:**

- Die Datenbank *Objekte im Netz* enthält mehrere Teil-Sammlungen, die einzeln 
  übernommen werden, beispielsweise die Musikinstrumente-Sammlung (Sammlungs-ID 4). 

- Das virtuelle Münzportal KENOM ist eine Forschungsdatenbank deren Inhalt
  als ganzes übernommen wird (Sammlungs-ID 7).

- Der Datensatz *Ogham Data* wurde unabhängig von einer Forschungsdatenbank im
  allgemeinen Repository Zenodo unter der DOI <https://doi.org/10.5281/zenodo.4765603>
  publiziert (Sammlungs-ID 9) und wird einzeln übernommen.

Die empfangenen RDF-Daten werden syntaktisch geprüft und rudimentär bereinigt
im Verzeichnis `import` abgelegt (Datei `absolute.nt`).

Darüber hinaus wird eine Statistik der verwendeten RDF-Properties und der
RDF-Namensräume von Subjekt- und Objekt-URIs erstellt. Letztere werden mit
bekannten Namensräumen in der Datei `namespaces.csv` abgeglichen
(siehe auch die kuratierte Liste von Terminologien mit Namensräumen unter
<https://nfdi4objects.github.io/n4o-terminologies/>).
