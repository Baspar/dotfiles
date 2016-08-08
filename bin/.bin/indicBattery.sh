#!/bin/bash


[ $1 ] && pc=$1 || pc=$(cat ~/.bin/battery.d | head -n 1)

[ $2 ] && length=$2 || length=50

npc=$((pc * length / 100))

str="["
for i in $(seq 0 $length)
do
    if [ $i -le $npc ]
    then
        str="$str="
    else
        str=$str"_"
    fi
done
str="$str]"

mid=$((length/2+1))

str=$(echo $str | sed "
    s/./|/$((mid-1));
    s/./%/$((mid+3));
    s/./|/$((mid+4))")

if [ $pc -lt 10 ]
then
    str=$(echo $str | sed "
        s/./_/$((mid));
        s/./_/$((mid+1));
        s/./$pc/$((mid+2))")
elif [ $pc -le 99 ]
then
    str=$(echo $str | sed "
        s/./_/$((mid));
        s/./$((pc/10))/$((mid+1));
        s/./$((pc%10))/$((mid+2))")
else
    str=$(echo $str | sed "
        s/./1/$((mid));
        s/./0/$((mid+1));
        s/./0/$((mid+2))")
fi
echo $str | sed 's/_/ /g'
