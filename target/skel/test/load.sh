#!/bin/sh

cd /lib/modules/`uname -r`/kernel/drivers/video
insmod cfbimgblt.ko
insmod cfbfillrect.ko
insmod cfbcopyarea.ko

cd /lib/modules/`uname -r`/kernel/drivers/gpu
insmod mali/ump/ump.ko
insmod mali/mali/mali.ko

cd /lib/modules/`uname -r`/kernel/drivers/video/sunxi
insmod disp/disp.ko
insmod lcd/lcd.ko
insmod hdmi/hdmi.ko





