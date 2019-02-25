#!/bin/bash
FILE=~/.bin/pid/volume
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

STATE=$(pulseaudio-ctl full-status | cut -d ' ' -f 2)
pactl set-sink-volume 0 -5%
PERCENTAGE=$(pulseaudio-ctl full-status | cut -d ' ' -f 1)

if [ $STATE == "no" ]
then
    CHAR="█"
else
    CHAR="░"
fi

notify-send \
    -t 1000 \
    -r $pid \
    "$(~/.bin/indicBattery.sh $PERCENTAGE -w 50 -c $CHAR)"
