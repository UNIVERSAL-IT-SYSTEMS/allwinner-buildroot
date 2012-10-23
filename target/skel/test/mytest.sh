#!/bin/ash

/bin/dwin&

sleep 3

#infow 0 5 "POWER-KEY" ""
infow 1 5 "IR" ""
infow 2 5 "NETWORK" ""
infow 3 5 "SATA" ""
infow 4 5 "UDISK" ""
infow 5 5 "MMC" ""

for item in $(ls /sys/class/input |grep event)
do
	DNAME=`cat /sys/class/input/$item/device/name`

	case $DNAME in

#	axp20-supplyer)
#		logw "INFO: $item, $DNAME"
#		logw "Please press power key"
#		/bin/myevtest /dev/input/$item
#		RESULT=$?
#		if [ "$RESULT" -eq 0 ]; then
#			infow 0 2 "POWER-KEY" "OK"
#		else
#			infow 0 1 "POWER-KEY" "Failed"
#		fi
#	;;
	
	sun4i-ir)
		logw "INFO: $item, $DNAME"
		logw "Please press ir remote"
		/bin/myevtest /dev/input/$item
		RESULT=$?
		if [ "$RESULT" -eq 0 ]; then
			infow 1 2 "IR" "OK"
		else
			infow 1 1 "IR" "Failed"
		fi
	;;
	
	*)
		echo "#######################Skip############################"
		echo "INFO: $item, $DNAME"
		;;
	esac
done

#network
logw "Start discovering network"
/etc/init.d/auto_config_network
logw "Start ping 192.168.1.1"
/etc/init.d/auto_config_network
ping -c 5 192.168.1.1
RESULT=$?
if [ "$RESULT" -eq 0 ]; then
	infow 2 2 "NETWORK" "OK"
else
	infow 2 1 "NETWORK" "Failed"
fi
logw "Network test ends"

#sata
logw "Start reading from /dev/sda"
dd if=/dev/sda of=/tmp/sdafile bs=1024 count=16 seek=16
RESULT=$?
if [ "$RESULT" -eq 0 ]; then
	infow 3 2 "SATA" "OK"
else
	infow 3 1 "SATA" "Failed"
fi
logw "SATA test ends"

#udisk
logw "Start reading from /dev/sdb"
dd if=/dev/sdb of=/tmp/sdbfile bs=1024 count=16 seek=16
RESULT=$?
if [ "$RESULT" -eq 0 ]; then
	infow 4 2 "UDISK" "OK"
else
	infow 4 1 "UDISK" "Failed"
fi
logw "UDISK test ends"

#mmc
logw "Starting reading from /dev/mmcblk0"
dd if=/dev/mmcblk0 of=/tmp/mmcfile bs=1024 count=16 seek=16
RESULT=$?
if [ "$RESULT" -eq 0 ]; then
	infow 5 2 "MMC" "OK"
else
	infow 5 1 "MMC" "Failed"
fi
logw "MMC test ends"

#video
logw "Start playing video"
/test/td -t 30 -s 6 -c "/bin/CedarXPlayerTest /root/test1.mp4"
