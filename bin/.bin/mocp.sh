#!/bin/bash
mocp -i 2&>/dev/null && {
    mocp -i | grep "TotalTime" >>/dev/null &&{
        state=$(mocp -i | grep "State" | cut -d' ' -f 2)
        cur=$(mocp -i | grep CurrentSec | cut -d' ' -f2)
        tot=$(mocp -i | grep TotalSec| cut -d' ' -f2)
        [ "$state" == "PLAY" ] && echo "P" || echo "p"
        echo "$cur * 100 / $tot" | bc
    } || {
        echo "S"
        echo "0"
    }
} || {
    echo "K"
    echo "0"
}
