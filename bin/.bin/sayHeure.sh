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

notify-send \
    -r $pid \
    "$hour" \
    "$date"
