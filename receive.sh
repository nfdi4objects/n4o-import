#!/usr/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 INPUT_FILE COLLECTION_ID"
  exit
fi

inputfile=$1
collection=$2

if [[ ! "$collection" =~ ^[1-9][0-9]*$ ]]; then
  echo "COLLECTION_ID muss numerisch sein!"
  exit 1
fi

echo "Empfange RDF-Daten aus im Turtle-Format aus $1"
triples=`rapper -q -i turtle "$inputfile" | wc -l`

echo "Datei ist syntaktisch korrektes RDF"
echo "Anzahl der Tripel: $triples"

dir=import/$collection
rm -rf "$dir"
mkdir -p $dir

cp $inputfile $dir/original.ttl
echo "Originaldatei in $dir/original.ttl"
rapper -q -i turtle "$inputfile" > $dir/raw.nt
echo "NTriples in $dir/raw.nt"

# Verschiedene Statistiken

<$dir/raw.nt awk '{print $2}' | sort | uniq -c | sort -nrk1 > $dir/properties
echo "Statistik der Properties: $dir/properties"
echo "Anzahl verschiedener Properties:" `<$dir/properties wc -l`

# TODO: weitere Validierung

