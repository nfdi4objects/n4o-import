#!/usr/bin/bash

for qid in "$@"; do
    curl -s https://www.wikidata.org/wiki/Special:EntityData/$qid.rdf?flavor=simple > wikidata/$qid.rdf
    rapper -q -i rdfxml -I http://www.wikidata.org/entity/$qid wikidata/$qid.rdf | \
        npm run --silent rdffilter -- -f wikidata/filter.js > wikidata/$qid.nt
    wc -l wikidata/$qid.nt
    sleep 1
done
