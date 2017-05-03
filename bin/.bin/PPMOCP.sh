#!/bin/bash

MOCP=$(ps aux | grep mocp | grep -v grep | wc -l)

if [ $MOCP -ne 0 ]
then
    mocp -G
    INFO=$(mocp -i | tr '\n' '#')
    State=$(echo $INFO | tr '#' '\n' | grep State | sed 's/State:\ //g')
    if [[ $State == "STOP" ]]
    then
        {
            termite -t "MOCP - Music Player" --geometry=800x450+400+225 -e mocp && i3-msg workspace back_and_forth
        }&
    fi
else
    {
        termite -t "MOCP - Music Player" --geometry=800x450+400+225 -e mocp && i3-msg workspace back_and_forth
    }&
fi

~/.bin/sayMOCP.sh
