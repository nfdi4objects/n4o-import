#!/usr/bin/bash
set -euo pipefail

echo "receive valid LIDO XML"
./receive 0 test/data/LIDO-v1.1-Example_FMobj20344012-Fontana_del_Moro.xml > /dev/null
echo "OK"

echo "receive invalid LIDO XML"
if ./receive 0 test/data/LIDO-invalid.xml > /dev/null; then
    echo "OK"
else
    echo "FAILED"
fi

echo "receive valid RDF"
./receive 0 test/data/valid-rdf.ttl > /dev/null
