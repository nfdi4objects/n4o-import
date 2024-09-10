# RDF-Import für NFDI4Objects

[Dieses Repository](https://github.com/nfdi4objects/n4o-import) enthält Skripte zur Annahme, Prüfung, Bereinigung und Einspielung von Daten in den [Knowledge-Graphen von NFDI4Objects](https://graph.nfdi4objects.net/). Bei den Daten handelt es sich zum einen um Lieferungen von Forschungsdaten und zum anderen um Ontologien und andere Vokabulare. Forschungsdaten müssen in LIDO-XML oder in RDF vorliegen.


## Inhalt

- [Installation](#installation)
- [Voraussetzungen](#voraussetzungen)
- [Datenannahme und Prüfung](#datenannahme-und-prüfung)
- [Import von Forschungsdaten](#import-von-forschungsdaten)
- [Import von Vokabularen](#import-von-vokabularen)

[n4o-databases]: https://github.com/nfdi4objects/n4o-databases/
[n4o-terminologies]: https://github.com/nfdi4objects/n4o-terminologies/


## Installation

~~~sh
git clone https://github.com/nfdi4objects/n4o-import.git && cd n4o-import
~~~

Benötigt werden Standard-Kommandozeilenwerkzeuge (git, grep...) sowie rapper, xmllint, xmlstarlet, jq und Python 3. Unter Ubuntu lassen sie sich folgendermaßen installieren:

~~~
sudo apt-get install raptor2-utils libxml2-utils xmlstarlet jq python3
~~~

Darüber hinaus muss Node mindestens in Version 18, besser 20 installiert sein (Empfehlung zur Installation: [nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)).

Zusätzliche Abhängigkeiten werden anschließend mit `make update` installiert. Dies beinhaltet:

- Die Liste von Datenquellen aus [n4o-databases]
- Das LIDO-Schema aus [lido-schema](https://github.com/nfdi4objects/lido-schema/)
- Benötigte Node-Pakete (`npm install`)

Schließlich müssen als Backend ein lokaler Triple-Store (bislang unterstützt: Fuseki) und eine Property-Graph-Datenbank (bislang unterstützt: Neo4J) vorhanden sein. In Fuseki muss der Default-Graph mit folgender Einstellung in `/etc/fuseki/configuration/n4o-rdf-import.ttl` als Union-Graph konfiguriert werden:

~~~
:tdb_dataset_readwrite tdb2:unionDefaultGraph true;
~~~

## Voraussetzungen

Alle zu importierenden Forschungsdaten müssen genau einer "Sammlung" zugeordnet
sein. Eine Sammlung im Sinne des Import ist eine Menge von Daten in LIDO oder
RDF, die als ganzes importiert und aktualisiert werden kann. Zusätzlich müssen
Sammlungen einem übergreifenden Forschungsdaten-Repository
zugeordnet sein. Die Verwaltung von Sammlungen geschieht derzeit über
das git-Repository [n4o-databases].

Weitere Anforderungen an Datenlieferungen sind [im Handbuch des N4O Graph](https://nfdi4objects.github.io/n4o-graph/sources.html) beschrieben.

Alle offiziell unterstützen Terminologien (Normdateien und Ontologien) sind
ebenfalls im Repository [n4o-terminologies] aufgeführt. Sie werden gesondert in den
Knowledge Graphen eingespielt.


## Datenannahme und Prüfung

Die **Datenannahme und Prüfung** beinhaltet:

1. Die eindeutige Zuordnung von gelieferten Dateien zu definierten Sammlungen
2. Die syntaktische Prüfung der Daten (wohlgeformtes XML bzw. RDF)
3. Im Falle von XML-Daten die Validierung gegen das LIDO-XML-Format
4. Im Falle von RDF-Daten das Aussortieren von doppelten Tripeln, Tripeln mit relativen URIs und Tripeln, die  Aussagen über die zentral verwalteten Vokabulare machen
5. Erstellung von Statistiken und Übersichten verwendeter RDF-Properties und Namensräume bzw. von verwendeten XML-Elementen zur Einschätzung der Nutzbarkeit der Daten

**Beispiele:** (könnten ins Handbuch verschoben werden)

- Die Datenbank *Objekte im Netz* enthält mehrere Teil-Sammlungen, die einzeln 
  übernommen werden, beispielsweise die Musikinstrumente-Sammlung (Sammlungs-ID 4). 

- Das virtuelle Münzportal KENOM ist eine Forschungsdatenbank deren Inhalt
  als ganzes übernommen wird (Sammlungs-ID 7).

- Der Datensatz *Ogham Data* wurde unabhängig von einer Forschungsdatenbank im
  allgemeinen Repository Zenodo unter der DOI <https://doi.org/10.5281/zenodo.4765603>
  publiziert (Sammlungs-ID 9) und wird einzeln übernommen.

Zur Durchführung der Datenannahme muss eine Lieferung in Form einer Datei irgendwo im lokalen Dateisystem vorliegen. Es empfiehlt sich, die Datei im Verzeichnis `inbox` abzulegen, damit sie bei Bedarf für weitere Prüfungen zur Verfügung gestellt werden kann. Das Skript [`receive`](receive) erwartet eine vorab definierte Sammlungs-ID und die entsprechende RDF/Turtle- oder LIDO-XML-Datei.

Die empfangenen RDF- bzw. LIDO-Daten werden syntaktisch geprüft und rudimentär
bereinigt in einem Unterverzeichnis von [`import`](import) mit der jeweiligen
Sammlungs-ID abgelegt. Das betreffende Import-Verzeichnis enthält verschiedene
Report-Dateien mit Statistiken und im Erfolgsfall die Datei `filtered.nt` für
geprüfte und bereinigte RDF-Daten bzw. die Datei `valid.xml` für geprüfte
LIDO-Daten.

Darüber hinaus wird für RDF-Daten eine Statistik der verwendeten RDF-Properties
und der RDF-Namensräume von Subjekt- und Objekt-URIs erstellt. Letztere werden
mit bekannten Namensräumen abgeglichen (siehe [n4o-terminologies]).


## Import von Forschungsdaten

Das Einspielen der bereinigten RDF-Daten als Named Graph in einen lokalen Fuseki RDF-Triple-Store bzw. das Konvertieren der LIDO-XML-Daten zur Einspielung in den gemeinsamen Knowledge Graphen erfolgt mit folgenden Skripten.

### Einspielen von RDF-Daten in den Triple-Store

Mit dem Skript `load-rdf` können Sammlungen und Informationen über Sammlungen
(sources) in einen lokalen RDF-Triple-Store (Fuseki) geladen werden, wobei die
vorhandenen RDF-Daten der Sammlung jeweils überschrieben werden. Beispiel:

~~~sh
./load-rdf 4
~~~

Vor dem Einspielen der RDF-Daten in einen Graphen mit der jeweiligen Sammlungs-URI (hier <https://graph.nfdi4objects.net/collection/4>) wird der Graph 
<https://graph.nfdi4objects.net/collection/> mit Verwaltungsdaten _über_ die Sammlungen aktualisiert.
Diese Metadaten können auch folgendermaßen unabhängig von den eigentlichen Forschungsdaten aktualisiert werden:

~~~sh
./load-rdf-metadata 4
~~~

Zum Löschen von Graphen kann die Fuseki-Weboberfläche mit dem `update` Endpunkt und dem Kommando `DROP GRAPH <...>` verwendet werden, allerdings wird der Graph mit den Verwaltungsdaten dabei nicht aktualisiert!

### Einspielen von RDF-Daten in den Property-Graphen

Neben der RDF-Kodierung sollen die Daten oder Teile davon in einen Property-Graphen überführt und dort mit anderen Daten zusammengeführt werden. Siehe dazu das Code-Repository <https://github.com/nfdi4objects/n4o-property-graph/>.

### Einspielen von LIDO-Daten

*Noch in Arbeit*


## Import von Vokabularen

*Das Einspielung von Ontologien und anderen Vokabularen ist noch in Entwicklung.*

Zum Aktualisieren des Graph <https://graph.nfdi4objects.net/terminology/> mit Angaben *über* alle für N4O relevanten Vokabulare dient folgender Aufruf:

~~~sh
./load-terminologies
~~~

### Wikidata

Im Verzeichnis `wikidata` werden RDF-Daten aus Wikidata vorgehalten und können mit `load-wikidata` in den Triple-Store geladen werden.

Das Skript `extract-wikidata` ermittelt Wikidata-Entity-IDs aus der Liste von Datenbanken und läd diese von Wikidata.

~~~sh
./extract-wikidata
./load-wikidata
~~~

