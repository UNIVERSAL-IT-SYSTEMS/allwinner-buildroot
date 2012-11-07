#!/bin/ash


case $1 in
linkup)
        ping -w 1 192.168.1.1 > /dev/null
        if [ "$?" = "0" ]; then
			    infow 6 0 "          [EMAC][WangKou]" "ok" 2>/dev/null
        else
			    infow 6 1 "          [EMAC][WangKou]" "ping failed" 2>/dev/null
        fi
        ;;
*)
	    infow 6 1 "          [EMAC][WangKou]" "failed" 2>/dev/null
        ;;
esac
