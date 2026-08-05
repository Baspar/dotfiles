#!/bin/bash
operation=$1
sink=$2
file_prefix=~/.bin/pid/volume
sinks=$(pactl -f json list sinks | jq -r '.[] | [
    .description,
    .index,
    .mute,
    ([
      (.volume["front-left"].value_percent | rtrimstr("%") | tonumber),
      (.volume["front-right"].value_percent | rtrimstr("%") | tonumber)
    ] | max)
] |join("|")')

SINK_ID=$(echo "$sinks" | sed -n "${sink:=1}p" | cut -d\| -f2)

if [ "$operation" = "toggle" ]; then
    pactl set-sink-mute $SINK_ID toggle
else
    pactl set-sink-volume $SINK_ID ${operation}%
fi

sinks=$(pactl -f json list sinks | jq -r '.[] | [
    .description,
    .index,
    .mute,
    ([
      (.volume["front-left"].value_percent | rtrimstr("%") | tonumber),
      (.volume["front-right"].value_percent | rtrimstr("%") | tonumber)
    ] | max)
] |join("|")')

while read sink; do
    name=$(echo "$sink" | cut -d\| -f1)
    index=$(echo "$sink" | cut -d\| -f2)
    mute=$(echo "$sink" | cut -d\| -f3)
    volume=$(echo "$sink" | cut -d\| -f4)

    [ "$mute" = "true" ] && CATEGORY="MUTED" || CATEGORY="UNMUTED"

    PID=$(cat "$file_prefix-$index")
    [ "$PID" ] || {
        PID=$RANDOM
    }

    PID=$(notify-send.sh \
        -t 1000 \
        -r $PID \
        -p \
        --app-name=VOLUME \
        --category=$CATEGORY \
        --hint=int:value:$volume \
        "$name ($volume%)"
    )
    echo "$PID" > "$file_prefix-$index"
done < <(echo "$sinks")
