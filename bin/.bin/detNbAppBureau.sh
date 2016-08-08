#!/bin/zsh
final=(0 0 0 0 0 0 0 0 0 0)
num=$1

for i in $(wmctrl -l |sed 's/\ \+/\ /g'| cut -d ' ' -f 2 | grep -v "\-1")
do
    ii=$((i+1))
    val=$(( $final[$ii] +1 ))
    final[$ii]=$val
done
nb=$final[$((num+1))]
if [ $nb -lt 10 ]
then
    echo "[$nb]"
else
    echo "[$nb]"
fi
