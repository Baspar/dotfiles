#!/bin/bash
FILE=~/.bin/pid/volume
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

SINK_ID=$(ponymix list --sink | grep "^sink" | head -n $(($1 + 1)) | tail -n 1 | grep -o "sink [0-9]" | grep -o "[0-9]")
pactl set-sink-mute $SINK_ID toggle
INFO=$(ponymix list --sink | grep -v "^sink")
NB_SINK=$(($(echo "$INFO" | wc -l) / 2))
for i in $(seq $NB_SINK)
do
    NAME=$(echo "$INFO" | head -n $(((i - 1) * 2 + 1)) | tail -n 1)
    INFO_SINK=$(echo "$INFO" | cut -d \n -f $((i * 2 + 1))-$((i * 2 + 2)))
    STATE=$(echo "$INFO" | head -n $((i * 2)) | tail -n 1 | grep "Muted")
    PERCENTAGE=$(echo "$INFO" | head -n $((i * 2)) | tail -n 1 | grep -o "[0-9]\+%" | sed 's#%##')
    if [ "$STATE" ]
    then
        CHAR="░"
    else
        CHAR="█"
    fi

    notify-send \
        -t 1000 \
        -r $((pid + i)) \
        "$(~/.bin/indicBattery.sh $PERCENTAGE $NAME -w 50 -c $CHAR)"
done
