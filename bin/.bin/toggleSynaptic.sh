#!/bin/bash
pid=$(cat ~/.bin/notifypid)
if [[ $pid == "" ]]
then

    pid=1
fi
id=$(xinput list  | grep -i "touchpad" | sed 's/.*id=\([0-9]\+\).*/\1/g' | tail -n 1)
nouvelEtat=$(( ( $(xinput list-props $id | grep "Device Enabled" | sed 's/.*\([01]\)$/\1/g') + 1 ) % 2 ))
xinput -set-prop $id "Device Enabled" $nouvelEtat
if [ $nouvelEtat -eq 0 ]
then
    txt="désactivé"
else
    txt="activé"
fi
notify-send -p -r $pid -t 1000 -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/input-tablet.svg "Synaptic $txt"
