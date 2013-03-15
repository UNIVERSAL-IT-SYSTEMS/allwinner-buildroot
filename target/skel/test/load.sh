#!/bin/sh

modprobe disp                                                                                         
modprobe lcd                                                                                          
modprobe hdmi                                                                                         
modprobe sw_ahci_platform                                                                             
modprobe sun4i_ir                                                                                     
                                                                                                      
for item in $(ls /sys/class/input); do
    case $item in
	event*)
	    if cat /sys/class/input/$item/device/name |grep sun4i-ir; then
		echo "ir on $item"
		/test/bin/ir-runner /dev/input/$item 2>/dev/null
	    fi
	    ;;
	*)
	    ;;
    esac
done

