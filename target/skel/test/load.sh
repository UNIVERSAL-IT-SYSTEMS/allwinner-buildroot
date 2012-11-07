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


rm /dev/snd/pcmC0D0p /dev/snd/pcmC1D0p                                                                
mknod /dev/snd/pcmC0D0p c 116 48
mknod /dev/snd/pcmC1D0p c 116 16
/bin/CedarXPlayerTest /test/Logo.m4v 1>/dev/null
rm /dev/snd/pcmC0D0p /dev/snd/pcmC1D0p
mknod /dev/snd/pcmC0D0p c 116 16
mknod /dev/snd/pcmC1D0p c 116 48
