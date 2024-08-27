# RDF-Import für NFDI4Objects

[Dieses Repository](https://github.com/nfdi4objects/n4o-import) enthält
Skripte zur Prüfung von zu importierenden Daten in den oder die
Knowledge-Graphen von NFDI4Objects. Unterstützt werden

- XML-Daten im LIDO-Format
- RDF-Daten die sich auf CIDOC-CRM und/oder die NFDI4Objects Core Ontologie mappen lassen

Die **Datenannahme und Prüfung** beinhaltet:

1. Die eindeutige Zuordnung von gelieferten Daten zu definierten Sammlungen
2. Die syntaktische Prüfung der Daten (wohlgeformtes XML bzw. RDF)
3. Im Falle von XML-Daten die Validierung gegen das LIDO-XML-Format
4. Im Falle von RDF-Daten das Aussortieren von doppelten Tripeln, Tripeln mit relativen URIs und Tripeln, die eigeme Aussagen über die unterstützten Ontologien machen
5. Erstelle von Statistiken und Übersichten verwendeter RDF-Properties und Namensräume bzw. von verwendeten XML-Elementen zur Einschätzung der Nutzbarkeit der Daten

Das anschließende **Einspielen** der bereinigten RDF-Daten als Named Graph in einen lokalen Fuseki RDF-Triple-Store bzw. das Konvertieren der LIDO-XML-Daten zur Einspielung in den gemeinsamen Knowledge Graphen erfolgt anschließend in einem eigenen Schritt (siehe <https://github.com/nfdi4objects/n4o-property-graph/>).

## Voraussetzungen

Alle zu importierenden Daten müssen genau einer "Sammlung" zugeordnet sein.
Eine Sammlung im Sinne des Import ist eine Menge von Daten, die als ganzes
importiert und aktualisiert werden kann. Zusätzlich können Sammlungen einer
Datenbank aus <https://nfdi4objects.github.io/n4o-databases/> zugeordnet sein.
Unabhängige Sammlungen, die zu keiner Datenbank gehören, können auch als
einzelne Datenpublikationen angesehen werden.

Zum Update der Sammlungsliste ist `make` aufzurufen, um das Unterverzeichnis
`sources` zu erstellen.

## Benutzung

### Installation

~~~sh
git clone https://github.com/nfdi4objects/n4o-import.git && cd n4o-import
~~~

Benötigt werden Standard-Kommandozeilenwerkzeuge (grep, awk, sed...) sowie

- rapper (`sudo apt install raptor2-utils`)
- xmlstarlet
- jq (`sudo apt install jq`)
- Python 3
- Node >= 18

Zur Installation benötigter Pakete:

~~~sh
npm install
~~~

### Annahme und Erstkontrolle der Daten

Das Skript [`receive`](receive) erwartet eine Sammlungs-ID und eine RDF/Turtle-
oder LIDO-XML-Datei.

**Beispiele:**

- Die Datenbank *Objekte im Netz* enthält mehrere Teil-Sammlungen, die einzeln 
  übernommen werden, beispielsweise die Musikinstrumente-Sammlung (Sammlungs-ID 4). 

- Das virtuelle Münzportal KENOM ist eine Forschungsdatenbank deren Inhalt
  als ganzes übernommen wird (Sammlungs-ID 7).

- Der Datensatz *Ogham Data* wurde unabhängig von einer Forschungsdatenbank im
  allgemeinen Repository Zenodo unter der DOI <https://doi.org/10.5281/zenodo.4765603>
  publiziert (Sammlungs-ID 9) und wird einzeln übernommen.

Die empfangenen RDF- bzw. LIDO-Daten werden syntaktisch geprüft und rudimentär
bereinigt im Verzeichnis [`import`](import) abgelegt (Datei `filtered.nt` bzw.
`valid.xml`).

Darüber hinaus wird für RDF-Daten eine Statistik der verwendeten RDF-Properties
und der RDF-Namensräume von Subjekt- und Objekt-URIs erstellt. Letztere werden
mit bekannten Namensräumen in der Datei [`namespaces.csv`](namespaces.csv)
abgeglichen (siehe auch die kuratierte Liste von Terminologien mit Namensräumen
unter <https://nfdi4objects.github.io/n4o-terminologies/>).

### Einspielen in Triple-Store

Mit dem Skript `load-rdf` können anschließend Sammlungen und Informationen
über Sammlungen (sources) in einen lokalen RDF-Triple-Store (Fuseki) geladen
werden, wobei die vorhandenen RDF-Daten der Sammlung jeweils überschrieben
werden.

Zum Löschen von Graphen kann die Fuseki-Weboberfläche mit dem `update` Endpunkt verwendet und dem Kommando `DROP GRAPH <...>` verwendet werden.


### Konvertierung in Property-Graphen

Neben der RDF-Kodierung sollen die Daten oder Teile davon in einen Property-Graphen überführt und dort mit anderen Daten zusammengeführt werden. Siehe dazu das Code-Repository <https://github.com/nfdi4objects/n4o-property-graph/>.


## Einspielung von Vokabularen

### Wikidata

Im Verzeichnis `wikidata` werden RDF-Daten aus Wikidata vorgehalten und können mit `load-wikidata` in den Triple-Store geladen werden.

Das Skript `extract-wikidata` ermittelt Wikidata-Entity-IDs aus der Liste von Datenbanken und läd diese von Wikidata.

~~~sh
./extract-wikidata
./load-wikidata
~~~
