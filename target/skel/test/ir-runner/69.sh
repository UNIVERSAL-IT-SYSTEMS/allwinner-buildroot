#!/bin/ash

/test/ir-runner/89.sh
/test/bin/td -t 12 -s 6 -c "/bin/CedarXPlayerTest /test/Logo.m4v" 1>/dev/null
/test/ir-runner/77.sh
/test/bin/td -t 12 -s 6 -c "/bin/CedarXPlayerTest /test/Logo.m4v" 1>/dev/null
/test/ir-runner/89.sh

