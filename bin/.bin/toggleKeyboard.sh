#!/bin/bash
pid=$(cat ~/.bin/pid/keyboard)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi
id=$(xinput list  | grep "AT Translated Set 2 keyboard " | sed 's/.*id=\([0-9]\+\).*/\1/g')
nouvelEtat=$(( ( $(xinput list-props $id | grep "Device Enabled" | sed 's/.*\([01]\)$/\1/g') + 1 ) % 2 ))
xinput -set-prop $id "Device Enabled" $nouvelEtat
if [ $nouvelEtat -eq 0 ]
then
    img="gnome-lockscreen"
    txt="disabled"
else
    img="gtk-fullscreen"
    txt="enabled"
fi
notify-send -p -r $pid -t 1000 -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/"$img".svg "Tactile $txt"
