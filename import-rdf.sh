#!/usr/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 COLLECTION_ID|all"
  exit
fi
        
function import_collection() {
    collection=$1
    if [[ ! "$collection" =~ ^[0-9]*$ ]]; then
        echo "Collection ID must be numeric!"
        exit 1
    fi

    absolute=import/$collection/absolute.nt        
    if [[ -s "$absolute" ]]; then
        echo "Importing $absolute into Fuseki" 
        /opt/fuseki/bin/s-put http://localhost:3030/n4o-rdf-import \
            n4oc:$collection $absolute
    else
        echo "Missing RDF file: $absolute"
        exit 1
    fi
}

if [[ "$1" = "all" ]]; then
    for collection in import/*; do
        import_collection $(basename $collection)
    done
else
    import_collection $1
fi
