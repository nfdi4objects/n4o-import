#!/usr/bin/bash
set -euo pipefail

n4oc=https://graph.nfdi4objects.net/collection/

function import_file() {
    file=$1
    graph=$2
    if [[ -s "$file" ]]; then
        echo "Importing $file into Fuseki graph $graph"
        /opt/fuseki/bin/s-put http://localhost:3030/n4o-rdf-import $graph $file
    else
        echo "Missing RDF file: $file"
        exit 1
    fi
}

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 COLLECTION_ID|all|sources"
  echo "Imports into local Fuseki store"
  exit
fi

function import_collection() {
    collection=$1
    if [[ ! "$collection" =~ ^[0-9]*$ ]]; then
        echo "Collection ID must be numeric!"
        exit 1
    fi
    import_file "import/$collection/file.nt" "$n4oc$collection"
}

if [[ "$1" = "sources" ]]; then
    import_file "sources/n4o-sources.nt" "$n4oc"
elif [[ "$1" = "all" ]]; then
    for collection in import/*; do
        import_collection $(basename $collection)
    done
else
    import_collection $1
fi
