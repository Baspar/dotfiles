#!/bin/bash
THRESHOLD_WARNING=20
THRESHOLD_ALERT=5

PID_FILE=~/.bin/PID/battery
PID=$(cat $PID_FILE)
if [[ $PID == "" ]]
then
    PID=$RANDOM
    echo $PID > "$PID_FILE"
fi

case $(uname -n) in
    Baspar-frmwk)
        BATTERY_NUMBER=1
        ;;
    *)
        BATTERY_NUMBER=0
        ;;
esac

STATUS=$(cat /sys/class/power_supply/BAT$BATTERY_NUMBER/status)
FULL=$(cat /sys/class/power_supply/BAT$BATTERY_NUMBER/charge_full)
CURRENT=$(cat /sys/class/power_supply/BAT$BATTERY_NUMBER/charge_now)

OLD_BATTERY_LEVEL=$(cat ~/.bin/battery.d | sed -n 1p)
OLD_CHARGING_STATE=$(cat ~/.bin/battery.d | sed -n 2p)

BATTERY_LEVEL=$((100*CURRENT/FULL))

echo $BATTERY_LEVEL > ~/.bin/battery.d
echo $STATUS >> ~/.bin/battery.d

if [[ $STATUS != $OLD_CHARGING_STATE ]]; then
    notify-send.sh \
        -t 1000 \
        -r $PID \
        -p \
        --app-name=BATTERY \
        "Battery $STATUS ($BATTERY_LEVEL%)" > "$PID_FILE"
elif [ $BATTERY_LEVEL -lt $OLD_BATTERY_LEVEL ]; then
    if [ $BATTERY_LEVEL -le $THRESHOLD_ALERT ]; then
        notify-send.sh \
            -u critical \
            -r $PID \
            -p \
            --app-name=BATTERY \
            "Battery $STATUS ($BATTERY_LEVEL%)" > "$PID_FILE"
        sleep 5 && systemctl suspend
    elif [ $BATTERY_LEVEL -le $THRESHOLD_WARNING ]; then
        notify-send.sh \
            -u critical \
            -t 1000 \
            -r $PID \
            -p \
            --app-name=BATTERY \
            "Battery $STATUS ($BATTERY_LEVEL%)" > "$PID_FILE"
    fi
elif [ $BATTERY_LEVEL -eq 100 ] && [ $OLD_BATTERY_LEVEL -ne 100 ]; then
    notify-send.sh \
        -t 1000 \
        -r $PID \
        -p \
        --app-name=BATTERY \
        "Battery full" > "$PID_FILE"
fi

echo "Battery: $BATTERY_LEVEL%"
[ ${BATTERY_LEVEL} -le ${THRESHOLD_ALERT} ] && exit 33
[ ${BATTERY_LEVEL} -le ${THRESHOLD_WARNING} ] && echo "#FF8000"
