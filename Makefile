update:
	if [ -d sources ]; then git -C sources pull ; else git clone https://github.com/nfdi4objects/n4o-databases.git sources; fi

import-wikidata:
	rm -f wikidata/*.rdf wikidata/*.nt
	./get-wikidata-entity.sh `grep -o -E 'Q[0-9]+' sources/n4o-databases.csv`

load-wikidata:
	#npm run --silent load-wikidata
	./load-rdf-graph http://bartoc.org/en/node/1940 <(cat wikidata/*.nt)
