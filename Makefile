update:
	if [ -d sources ]; then git -C sources pull ; else git clone https://github.com/nfdi4objects/n4o-databases.git sources; fi

extract-wikidata:
	rm -f wikidata/*.rdf wikidata/*.nt
	./get-wikidata-entity.sh `grep -o -E 'Q[0-9]+' sources/n4o-databases.csv`
