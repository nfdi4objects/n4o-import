#!/usr/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 COLLECTION_ID INPUT_FILE"
  echo
  if [[ $# -eq 1 ]]; then
    grep -e "^$1," n4o-collections.csv
  else
    awk -F, 'NR>1{print $1,$2}' n4o-collections.csv
  fi
  exit
fi

collection=$1
input=$2

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

echo "Empfange RDF-Daten aus im Turtle-Format aus $input"
triples=`rapper -q -i turtle "$input" | wc -l`

echo "Datei ist syntaktisch korrektes RDF"
echo "Anzahl der Tripel: $triples"

dir=import/$collection
rm -rf "$dir"
mkdir -p $dir
raw=$dir/raw.nt

echo
cp $input $dir/original.ttl
echo "Originaldatei in $dir/original.ttl"
rapper -q --replace-newlines -i turtle "$input" > $raw
echo "NTriples in $raw"

# Relative URIs entfernen

absolute=$dir/absolute.nt

echo
<$raw awk '$1 !~ /^<file:/ && $2 !~ /<file:/ && $3 !~ /<file:/ { print }' > $absolute
a=$(<$raw wc -l)
b=$(<$absolute wc -l)
removed=$(($a-$b))

echo "RDF beschränkt auf absolute URIs in $dir/absolute.nt"
if [[ $removed -ne "0" ]]; then
  echo "$removed triples mit relativen URIs entfernt!"
fi

# Verschiedene Statistiken

properties=$dir/properties
echo
<$absolute awk '{print $2}' | sort | uniq -c | sort -nrk1 > $properties
echo "Statistik der Properties: $properties"
echo "Anzahl verschiedener Properties:" `<$properties wc -l`
head -3 $properties

namespaces=$dir/namespaces
echo
# Heuristik zur Extraktion von Namensräumen aus absoluten URIs
<$absolute awk '{print $1} $3~/^</ {print $3}' | sed 's/^<//' | \
    sed 's/#.*$/#/;t;s|/[^/]*>$|/|;t;s/:.*$/:/' | \
    sort | uniq -c | sort -nrk1 > $namespaces
echo "Statistik der Namensräume (nur Subjekte und Objekte): $namespaces"
echo "Anzahl verschiedener Namensräume:" `<$namespaces wc -l`
echo "Bekannte Namensräume:"
<$namespaces ./known-namespaces.py

