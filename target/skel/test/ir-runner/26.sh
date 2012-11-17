#!/bin/ash

MAC_ADDR="`uuidgen |awk -F- '{print $5}'|sed 's/../&:/g'|sed 's/\(.\)$//' |cut -b3-17`"
ifconfig eth0 hw ether "48$MAC_ADDR"
ifconfig lo 127.0.0.1
#ifconfig eth0 192.168.1.2/24
udhcpc -t 1 -n


if ! /bin/ps |grep dwin |grep -v grep
then
        echo "run dwin"
        dwin &
        /test/ir-runner/storage.sh
else
        echo "kill dwin"
        killall dwin
fi

