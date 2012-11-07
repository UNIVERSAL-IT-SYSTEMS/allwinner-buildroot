#!/bin/ash

ata_flag="nok"
udisk_flag="nok"
mmc_flag="nok"

for item in $(ls /sys/block/sd[a-z])
do
        echo $item
        if cat $item/device/vendor | grep ATA
        then
                ata_flag="ok"
        else
                udisk_flag="ok"
        fi
done

for item in $(ls /sys/block/mmcblk[0-9])
do
        mmc_flag="ok"
done

infow 2 0 '          [IR][HongWai]        ' ok

if [ "$ata_flag" = "ok" ]; then
	    infow 3 0 '          [SATA][YingPan]      ' ok
else
	    infow 3 1 '          [SATA][YingPan]      ' no
fi


if [ "$udisk_flag" = "ok" ]; then
	    infow 4 0 '          [USB][U Pan]         ' ok
else                                    
	    infow 4 1 '          [USB][U Pan]         ' no
fi

if [ "$mmc_flag" = "ok" ]; then
	    infow 5 0 '          [SDCARD][SD Ka]      ' ok
else
	    infow 5 1 '          [SDCARD][SD Ka]      ' no
fi
