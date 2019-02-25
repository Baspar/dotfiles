#!/bin/bash
FILE=~/.bin/pid/volume
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

# pulseaudio-ctl up 5
pactl set-sink-volume 0 +5%
STATE=$(pulseaudio-ctl full-status | cut -d ' ' -f 2)
PERCENTAGE=$(pulseaudio-ctl full-status | cut -d ' ' -f 1)

if [ $STATE == "no" ]
then
    CHAR="█"
else
    CHAR="░"
fi

notify-send \
    -t 1000 \
    -p \
    -r $pid \
    "$(~/.bin/indicBattery.sh $PERCENTAGE 50 $CHAR)"
