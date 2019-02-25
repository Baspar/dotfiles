#!/bin/bash
FILE=~/.bin/pid/battery

pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

info=$(acpi | cut -d: -f2 | sed "s/[ %]//g" | cut -d, -f-2)


bat=$(echo $info | cut -d, -f2)
state=$(echo $info | cut -d, -f1)

notify-send \
    -r $pid
    "Battery ($state)" \
    "$(~/.bin/indicBattery.sh $bat)"
