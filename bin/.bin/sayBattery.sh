#!/bin/bash
FILE=~/.bin/pid/battery

pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
fi

bat=$(cat ~/.bin/battery.d | head -n 1)
state=$(cat ~/.bin/battery.d | head -n 2 | tail -n 1)
notify-send -p -r $pid -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Batterie ($state)" "$(~/.bin/indicBattery.sh)"
