#!/bin/bash
operation=$1
sink_id=$2

selected_sink_file=~/.bin/pid/volume-selected
selected_sink_index=$(cat "$selected_sink_file" || echo 0)

sink_indexes=$(pactl -f json list sinks | jq -r 'map(select(.ports | any(.type != "Line")))[] | .name')
selected_sink_name=$(echo "$sink_indexes" | sed -n "$((selected_sink_index+1))p")
nb_sinks=$(echo "$sink_indexes" | wc -l)

case "$operation" in
    next)
        selected_sink_index=$((selected_sink_index+1))
        ;;
    previous)
        selected_sink_index=$((selected_sink_index-1))
        ;;
    default)
        pactl set-default-sink $selected_sink_name
        ;;
    toggle)
        pactl set-sink-mute $selected_sink_name toggle
        ;;
    *)
        pactl set-sink-volume $selected_sink_name ${operation}%
        ;;
esac

selected_sink_index=$(((selected_sink_index+nb_sinks) % nb_sinks))
echo -n "$selected_sink_index" > "$selected_sink_file"

default_sink_name=$(pactl get-default-sink)

sinks=$(pactl -f json list sinks | jq -r 'map(select(.ports | any(.type != "Line")))[] | [
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
    if [ "$name" = "$default_sink_name" ] && [ "$id" -eq "$((selected_sink_index + 1))" ]; then
        icon="◉"
    elif [ "$name" = "$default_sink_name" ]; then
        icon="○"
    elif [ "$id" -eq "$((selected_sink_index + 1))" ]; then
        icon="•"
    else
        icon=" "
    fi

    if [ "$mute" = "true" ]; then
        CATEGORY="MUTED"
    else
        CATEGORY="UNMUTED"
    fi

    notify-send.sh \
        -t 1000 \
        -R ~/.notif-pid/vol-$id \
        --app-name=VOLUME \
        --category=$CATEGORY \
        --hint=int:value:$volume \
        "$icon $description ($volume%)"
done < <(echo "$sinks" | nl -w1 -s' ' | tac)
