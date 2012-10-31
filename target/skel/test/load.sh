#!/bin/sh

insmod /lib/modules/`uname -r`/kernel/drivers/video/cfbimgblt.ko
insmod /lib/modules/`uname -r`/kernel/drivers/video/cfbfillrect.ko
insmod /lib/modules/`uname -r`/kernel/drivers/video/cfbcopyarea.ko

insmod /lib/modules/`uname -r`/kernel/drivers/gpu/mali/ump/ump.ko
insmod /lib/modules/`uname -r`/kernel/drivers/gpu/mali/mali/mali.ko

insmod /lib/modules/`uname -r`/kernel/drivers/video/sunxi/disp/disp.ko
insmod /lib/modules/`uname -r`/kernel/drivers/video/sunxi/lcd/lcd.ko
insmod /lib/modules/`uname -r`/kernel/drivers/video/sunxi/hdmi/hdmi.ko

insmod /lib/modules/`uname -r`/kernel/drivers/ata/sw_ahci_platform.ko
insmod /lib/modules/`uname -r`/kernel/drivers/input/keyboard/sun4i-ir.ko

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
