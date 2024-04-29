#!/usr/bin/bash
set -euo pipefail

./receive 0 test/LIDO-v1.1-Example_FMobj20344012-Fontana_del_Moro.xml

./receive 0 test/LIDO-invalid.xml
