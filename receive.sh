#!/usr/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 INPUT_FILE COLLECTION_ID"
  exit
fi

inputfile=$1
collection=$2

if [[ ! "$collection" =~ ^[0-9]*$ ]]; then
  echo "COLLECTION_ID muss numerisch sein!"
  exit 1
fi

if [[ $collection -eq "0" ]]; then
  echo "0 = Testcollection"
else
  name=$(awk -F, "\$1 == $collection {print \$2}" n4o-collections.csv)
  if [[ -z "$name" ]]; then
    echo "COLLECTION_ID $collection unbekannt!"
    exit 1
  fi
  echo "$collection = $name"
fi

echo "Empfange RDF-Daten aus im Turtle-Format aus $1"
triples=`rapper -q -i turtle "$inputfile" | wc -l`

echo "Datei ist syntaktisch korrektes RDF"
echo "Anzahl der Tripel: $triples"

dir=import/$collection
rm -rf "$dir"
mkdir -p $dir

echo
cp $inputfile $dir/original.ttl
echo "Originaldatei in $dir/original.ttl"
rapper -q --replace-newlines -i turtle "$inputfile" > $dir/raw.nt
echo "NTriples in $dir/raw.nt"

# Dubiose URIs entfernen

echo
<$dir/raw.nt awk '$1 !~ /^<file:/ && $2 !~ /<file:/ && $3 !~ /<file:/ { print }' > $dir/clean.nt
a=$(<$dir/raw.nt wc -l)
b=$(<$dir/clean.nt wc -l)
removed=$(($a-$b))

echo "Saubere URIs in $dir/clean.nt"
if [[ $removed -ne "0" ]]; then
  echo "$removed triples entfernt!"
fi

# Verschiedene Statistiken

echo
<$dir/clean.nt awk '{print $2}' | sort | uniq -c | sort -nrk1 > $dir/properties
echo "Statistik der Properties: $dir/properties"
echo "Anzahl verschiedener Properties:" `<$dir/properties wc -l`
head -3 $dir/properties

echo
<$dir/clean.nt awk '{print $1}' | sed 's|[^/]*>$||;s|^<||' | grep -v '^_:' | sort | uniq -c | sort -nrk1 > $dir/namespaces
echo "Anzahl verschiedener Namesräume von Subjekten:" `<$dir/namespaces wc -l`
head -3 $dir/namespaces


