#!/bin/bash
FILE=~/.bin/pid/keyboard
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

KEYBOARD="smc::kbd_backlight"

FULL=$(cat /sys/class/leds/$KEYBOARD/max_brightness)
CURRENT=$(cat /sys/class/leds/$KEYBOARD/brightness)

PERCENTAGE=$(expr $CURRENT \* 100 / $FULL)
NEW_PERCENTAGE=$(expr $PERCENTAGE + 10)
NEW_BRIGHTNESS=$(( $NEW_PERCENTAGE < 100 ? $NEW_PERCENTAGE : 100 ))

echo $(expr $NEW_BRIGHTNESS \* $FULL / 100) > /sys/class/leds/$KEYBOARD/brightness

notify-send \
    -r $pid \
    -t 1000 \
    "$(./indicBattery.sh $NEW_PERCENTAGE)"
