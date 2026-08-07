#!/bin/bash
operation=$1
sink_id=$2
file_prefix=~/.bin/pid/volume
default_sink_name=$(pactl get-default-sink)
sinks=$(pactl -f json list sinks | jq -r '.[] | [
    .name,
    .description,
    .index,
    .mute,
    ([
      (.volume["front-left"].value_percent | rtrimstr("%") | tonumber),
      (.volume["front-right"].value_percent | rtrimstr("%") | tonumber)
    ] | max)
] |join("|")')

SINK_ID=$(echo "$sinks" | sed -n "${sink_id:=1}p" | cut -d\| -f3)

if [ "$operation" = "toggle" ]; then
    pactl set-sink-mute $SINK_ID toggle
else
    pactl set-sink-volume $SINK_ID ${operation}%
fi

sinks=$(pactl -f json list sinks | jq -r '.[] | [
    .name,
    .description,
    .index,
    .mute,
    ([
      (.volume["front-left"].value_percent | rtrimstr("%") | tonumber),
      (.volume["front-right"].value_percent | rtrimstr("%") | tonumber)
    ] | max)
] |join("|")')

while read sink; do
    id=$(echo "$sink" | cut -d' ' -f1)
    name=$(echo "$sink" | cut -d' ' -f2- | cut -d\| -f1)
    description=$(echo "$sink" | cut -d' ' -f2- | cut -d\| -f2)
    index=$(echo "$sink" | cut -d' ' -f2- | cut -d\| -f3)
    mute=$(echo "$sink" | cut -d' ' -f2- | cut -d\| -f4)
    volume=$(echo "$sink" | cut -d' ' -f2- | cut -d\| -f5)

    icon=" "
    if [ "$name" = "$default_sink_name" ] && [ "$id" -eq "${sink_id:=1}" ]; then
        icon="◉"
    elif [ "$name" = "$default_sink_name" ]; then
        icon="○"
    elif [ "$id" -eq "${sink_id:=1}" ]; then
        icon="•"
    else
        icon=" "
    fi

    if [ "$mute" = "true" ]; then
        CATEGORY="MUTED"
    else
        CATEGORY="UNMUTED"
    fi

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
        "$icon $description ($volume%)"
    )
    echo "$PID" > "$file_prefix-$index"
done < <(echo "$sinks" | nl -w1 -s' ' | tac)
