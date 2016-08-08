#!/bin/zsh
final=(0 0 0 0 0 0 0 0 0 0)

for i in $(wmctrl -l |sed 's/\ \+/\ /g'| cut -d ' ' -f 2 | grep -v "\-1")
do
    ii=$((i+1))
    val=$(( $final[$ii] +1 ))
    final[$ii]=$val
done

echo $final[1] $final[2] $final[3]
echo $final[4] $final[5] $final[6]
echo $final[7] $final[8] $final[9]
