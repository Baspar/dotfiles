#!/bin/bash
FILE=~/.bin/pid/volume

# pulseaudio-ctl up 5
SINK_ID=$(ponymix list --sink | grep "^sink" | head -n $(($1 + 1)) | tail -n 1 | grep -o "sink [0-9]" | grep -o "[0-9]")
pactl set-sink-volume $SINK_ID +5%
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
        CATEGORY="MUTED"
    else
        CATEGORY="UNMUTED"
    fi

    PID=$(cat "$FILE-$i")
    [ "$PID" ] || {
        PID=$RANDOM
    }

    PID=$(notify-send.sh \
        -t 1000 \
        -r $PID \
        -p \
        --app-name=VOLUME \
        --category=$CATEGORY \
        --hint=int:value:$PERCENTAGE \
        "$NAME"
    )

    echo "$PID" > "$FILE-$i"
done
