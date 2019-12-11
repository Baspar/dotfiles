#!/bin/bash

WIDTH=50
CHARACTER="█"
ARGS=()

while [ $# -ne 0 ]
do
    case $1 in
        -w|--width)
            WIDTH=$2
            shift; shift;;
        -c|--character)
            CHARACTER=$2
            shift; shift;;
        *)
            [ "$PERCENTAGE" ] && {
                ARGS+=($1)
            } || {
                PERCENTAGE="$1"
            }
            shift;;
    esac
done

[ "$PERCENTAGE" ] || {
    PERCENTAGE=$(cat ~/.bin/battery.d | head -n 1)
}

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

[ ${#ARGS} -ne 0 ] && {
    echo "${ARGS[*]} $STR $(echo "${ARGS[*]}" | sed 's/./ /g')" | sed 's/_/ /g'
} || {
    echo $STR | sed 's/_/ /g'
}
