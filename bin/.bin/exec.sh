#!/bin/bash
#rofi -show run -font "monofur 10" -fg "#dfaf8f" -bg "#272521" -hlfg "#272521" -hlbg "#dfaf8f" -o 85

color1="202020"
color2="dfaf8f"

#rofi \
    #-show run  \
    #-font "MonofurForPowerline Nerd Font 29" \
    #-separator-style solid \
    #-eh 1.5\
    #-padding 50\
    #-hide-scrollbar \
    #-color-window "argb:dd$color1, argb:dd$color1, #$color2" \
    #-color-normal "argb:00$color1, #$color2, argb:00$color1, argb:00$color1, argb:55$color2"
rofi \
    -show run  \
    -font "MonofurForPowerline Nerd Font 30" \
    -bw 0 \
    -eh 2 \
    -lines 10 \
    -padding 50 \
    -separator-style solid \
    -hide-scrollbar \
    -color-window "argb:dd$color1, argb:dd$color1, #$color2" \
    -color-normal "argb:00$color1, #$color2, argb:00$color1, argb:00$color1, argb:55$color2"
