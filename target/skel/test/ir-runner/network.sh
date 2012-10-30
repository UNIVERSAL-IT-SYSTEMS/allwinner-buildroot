#!/bin/ash


case $1 in
linkup)
        ping -w 1 192.168.1.1 > /dev/null
        if [ "$?" = "0" ]; then
                infow 5 0 "[EMAC  ]" "ok" 2>/dev/null
        else
                infow 5 1 "[EMAC  ]" "ping failed" 2>/dev/null
        fi
        ;;
*)
        infow 5 1 "[EMAC  ]" "failed" 2>/dev/null
        ;;
esac
