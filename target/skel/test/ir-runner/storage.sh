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

infow 1 0 '[IR    ]' ok

if [ "$ata_flag" = "ok" ]; then
        infow 2 0 '[SATA  ]' ok
else
        infow 2 1 '[SATA  ]' no
fi


if [ "$udisk_flag" = "ok" ]; then
        infow 3 0 '[UDISK ]' ok              
else                                    
        infow 3 1 '[UDISK ]' no             
fi

if [ "$mmc_flag" = "ok" ]; then
        infow 4 0 '[MMC   ]' ok
else
        infow 4 1 '[MMC   ]' no
fi
