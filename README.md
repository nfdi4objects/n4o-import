# RDF-Import für NFDI4Objects

[Dieses Repository](https://github.com/nfdi4objects/n4o-rdf-import) enthält
Skripte zur Prüfung von zu importierenden RDF-Daten in den oder die
Knowledge-Graphen von NFDI4Objects.

Die **Datenannahme und Prüfung** beinhaltet:

1. Die eindeutige Zuordnung von gelieferten RDF-Daten zu definierten Sammlungen
2. Die syntaktische Prüfung der RDF-Daten
3. Aussortieren von doppelten Tripeln und RDF-Tripeln mit relativen URIs
4. Erste Statistik und Übersicht verwendeter Properties und RDF-Namensräume zur Einschätzung der Nutzbarkeit der Daten

Der anschließende **Import** besteht aus dem Einspielen der bereinigten RDF-Daten als Named Graph in einen lokalen Fuseki RDF-Triple-Store.

## Voraussetzungen

Alle zu importierenden Daten müssen genau einer "Sammlung" zugeordnet sein.
Eine Sammlung im Sinne des Import ist eine Menge von Daten, die als ganzes
importiert und aktualisiert werden kann. Zusätzlich können Sammlungen einer
Datenbank aus <https://nfdi4objects.github.io/n4o-databases/> zugeordnet sein.
Unabhängige Sammlungen, die zu keiner Datenbank gehören, können auch als
einzelne Datenpublikationen angesehen werden.

In [`n4o-collections.csv`](n4o-collections.csv) stehen bekannte Sammlungen und
Datenpublikationen, deren Daten übernommen werden können und falls vorhanden
die dazu gehörige übergeordnete Datenbank aus
<https://nfdi4objects.github.io/n4o-databases/>.

Das Skript `pg.py` konvertiert die Datei `n4o-collections.csv` ins PG format.
Mit `make` wird damit die Datei `no4-collections.pg` aktualisiert. Diese Datei
kann mit <https://github.com/nfdi4objects/n4o-databases/blob/main/n4o-databases.pg>
zusammengeführt werden.

## Benutzung

### Installation

~~~sh
git clone https://github.com/nfdi4objects/n4o-rdf-import.git && cd n40-rdf-import
~~~

Benötigt werden Standard-Kommandozeilenwerkzeuge (grep, awk, sed...) sowie

- rapper (`sudo apt install raptor2-utils`)
- jq (`sudo apt install jq`)
- Python 3

### Annahme und Erstkontrolle der Daten

Das Skript [`receive.sh`](receive.sh) erwartet eine Sammlungs-ID und eine RDF/Turtle-Datei.

**Beispiele:**

- Die Datenbank *Objekte im Netz* enthält mehrere Teil-Sammlungen, die einzeln 
  übernommen werden, beispielsweise die Musikinstrumente-Sammlung (Sammlungs-ID 4). 

- Das virtuelle Münzportal KENOM ist eine Forschungsdatenbank deren Inhalt
  als ganzes übernommen wird (Sammlungs-ID 7).

- Der Datensatz *Ogham Data* wurde unabhängig von einer Forschungsdatenbank im
  allgemeinen Repository Zenodo unter der DOI <https://doi.org/10.5281/zenodo.4765603>
  publiziert (Sammlungs-ID 9) und wird einzeln übernommen.

Die empfangenen RDF-Daten werden syntaktisch geprüft und rudimentär bereinigt
im Verzeichnis [`import`](import) abgelegt (Datei `absolute.nt`).

Darüber hinaus wird eine Statistik der verwendeten RDF-Properties und der
RDF-Namensräume von Subjekt- und Objekt-URIs erstellt. Letztere werden mit
bekannten Namensräumen in der Datei [`namespaces.csv`](namespaces.csv) abgeglichen
(siehe auch die kuratierte Liste von Terminologien mit Namensräumen unter
<https://nfdi4objects.github.io/n4o-terminologies/>).

### Import in Triple-Store

Mit dem Skript `import-rdf.sh` können anschließend Sammlungen in einen lokalen
RDF-Triple-Store (Fuseki) geladen werden, wobei die vorhandenen RDF-Daten der
Sammlung jeweils überschrieben werden.

### Konvertierung in Property-Graphen

Neben der RDF-Kodierun sollen die Daten oder Teile davon in einen Property-Graphen überführt und dort mit anderen Daten zusammengeführt werden. Das Datenmodell hierfür ist noch in Arbeit und wird mittelfristig mit der [NFDI4Objects Core Ontologie](https://nfdi4objects.github.io/n4o-core-ontology/)
synchronisiert werden.

Eine erste grobe Übersicht gibt die Liste von Node Labels und entsprechenden
RDF-Klassen aus verschiedenen unterstützen Datenformaten und Ontologien (insbesondere LIDO und CIDOC-CRM) in der Datei [`pg-model.csv`](pg-model.csv).

