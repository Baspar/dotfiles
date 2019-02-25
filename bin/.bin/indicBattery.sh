#!/bin/bash

[ $1 ] && PERCENTAGE=$1 || PERCENTAGE=$(cat ~/.bin/battery.d | head -n 1)

[ $2 ] && WIDTH=$2 || WIDTH=50

[ $3 ] && CHARACTER=$3 || CHARACTER="█"

npc=$((PERCENTAGE * WIDTH / 100))

STR="["
for i in $(seq 0 $WIDTH)
do
    if [ $i -le $npc ]
    then
        STR=$STR$CHARACTER
    else
        STR=$STR"_"
    fi
done
STR="$STR]"

mid=$((WIDTH/2+1))

STR=$(echo $STR | sed "
    s/./▌/$((mid-1));
    s/./%/$((mid+3));
    s/./▐/$((mid+4))")

if [ $PERCENTAGE -lt 10 ]
then
    STR=$(echo $STR | sed "
        s/./_/$((mid));
        s/./_/$((mid+1));
        s/./$PERCENTAGE/$((mid+2))")
elif [ $PERCENTAGE -le 99 ]
then
    STR=$(echo $STR | sed "
        s/./_/$((mid));
        s/./$((PERCENTAGE/10))/$((mid+1));
        s/./$((PERCENTAGE%10))/$((mid+2))")
else
    STR=$(echo $STR | sed "
        s/./1/$((mid));
        s/./0/$((mid+1));
        s/./0/$((mid+2))")
fi
echo $STR | sed 's/_/ /g'
