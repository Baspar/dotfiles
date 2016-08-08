#!/bin/bash
CMDD=$(xrandr --screen 0 | grep " connected" | sed 's/(.*$//g;s/.*[0-9]\+x[0-9]\++[0-9]\++[0-9]\+//g;s/ //g')

case $1 in
    "left")
        if [[ $CMDD == "right" ]]; then
            xrandr --screen 0 -o inverted
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 0
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 1 1
        elif [[ $CMDD == "inverted" ]]; then
            xrandr --screen 0 -o left
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 1
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 1 0
        elif [[ $CMDD == "left" ]]; then
            xrandr --screen 0 -o normal 
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 0
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 0 0
        else
            xrandr --screen 0 -o right
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 1
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 0 1
        fi
        ;;
    "right")
        if [[ $CMDD == "left" ]]; then
            xrandr --screen 0 -o inverted
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 0
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 1 1
        elif [[ $CMDD == "inverted" ]]; then
            xrandr --screen 0 -o right
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 1
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 0 1
        elif [[ $CMDD == "right" ]]; then
            xrandr --screen 0 -o normal 
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 0
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 0 0
        else
            xrandr --screen 0 -o left
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 1
            xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 1 0
        fi
        ;;
esac


