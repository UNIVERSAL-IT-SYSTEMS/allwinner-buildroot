#!/bin/ash

echo "After 3 seconds, input test start"
sleep 3
echo "input test start"

for item in $(ls /sys/class/input |grep event)
	do
	printf "$item ->"
	
	DNAME=`cat /sys/class/input/$item/device/name`
	printf "$DNAME ->"

	case $DNAME in
	  sun4i-ir)
	  echo "#######################TEST IR#########################"
	  echo "INFO: $item, $DNAME"
	  /test/td -t 10 -s 9 -c "/usr/bin/evtest /dev/input/$item"
	  ;;
	  *)
	  echo "#######################Skip############################"
	  echo "INFO: $item, $DNAME"
	  ;;
	esac
done

printf "\n\n#### Test CedarX(LCD) ####\n\n"
echo "turn off hdmi"
/test/display/fb_test.dat -o 1 0
echo "turn on hdmi"
/test/display/fb_test.dat -o 4 4
/test/td -t 15 -s 6 -c "/bin/CedarXPlayerTest /root/test1.mp4"

/test/display/fb_test.dat -o 1 0
/test/display/fb_test.dat -o 4 4


echo "Test Network start"
sleep 3
/etc/init.d/auto_config_network
ping -c 5 192.168.1.100


ls /dev/sd*
cat /proc/meminfo | grep MemTotal
/test/monitor



