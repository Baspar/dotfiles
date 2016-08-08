#/bin/bash
if [[ $(ps aux | grep tint2 | wc -l) -ge 2 ]]
then
    killall tint2
else
    tint2&
fi
