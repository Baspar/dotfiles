#!/bin/bash
FILE=~/.bin/pid/heure

pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi
date=$(date +"%d %h %Y")
hour=$(date +"%H:%M:%S")

notify-send -p -r $pid -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/status/notification-display-brightness-full.svg "$hour" "$date"
