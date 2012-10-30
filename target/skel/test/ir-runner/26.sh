#!/bin/ash

if ! /bin/ps |grep dwin |grep -v grep
then
        echo "run dwin"
        dwin &
        /test/ir-runner/storage.sh
else
        echo "kill dwin"
        killall dwin
fi

