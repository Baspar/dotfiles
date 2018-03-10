#!/bin/bash
KB="ANNE_KB_L0_0BD1"
while sleep 2
do
    if xinput list "$KB" >> /dev/null
    then
        echo "Connected"
        # xinput disable "AT Translated Set 2 keyboard"
    else
        echo "Disconnected"
        # xinput enable "AT Translated Set 2 keyboard"
    fi
done
