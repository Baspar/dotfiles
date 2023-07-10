#!/usr/bin/env bash
read -rs -d \\ -p $'\e]11;?\e\\' BG
rgb=$(echo "$BG" \
    | xxd -c 64 \
    | grep -o -E "rgb:.{4}/.{4}/.{4}" \
    | sed 's#rgb:\(..\)\1/\(..\)\2/\(..\)\3#\1|\2|\3|#g'
)

r=$(echo $rgb | cut -d'|' -f1 | echo $((16#$(cat))))
g=$(echo $rgb | cut -d'|' -f2 | echo $((16#$(cat))))
b=$(echo $rgb | cut -d'|' -f3 | echo $((16#$(cat))))
lum=$(( $r*$r + $g*$g + $b*$b ))
if [ $lum -gt 5000 ]; then
    echo "Light"
else
    echo "Dark"
fi
