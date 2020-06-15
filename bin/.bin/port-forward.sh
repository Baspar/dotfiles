#!/usr/bin/env bash
MODE="normal"
ADDRESS=""

while (( "$#" ))
do
    case "$1" in
        "--mock") 
            MODE="mock"
            shift
            ;;
        "--address") 
            ADDRESS="--address=$2"
            shift 2
            ;;
    esac
done

[ "$FZF_TMUX_HEIGHT" ] || {
  FZF_TMUX_HEIGHT="40%"
}
export FZF_DEFAULT_OPTS="--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse"

RESULT=$( \
  kubectl get services -A \
  | fzf --header-lines=1 --prompt="Select a service> " \
  | sed "s/ \{1,\}/|/g" \
  | cut -d\| -f1,2,6
)
NAMESPACE=$(echo $RESULT | cut -d\| -f 1)
SERVICE=$(echo $RESULT | cut -d\| -f 2)
PORTS=$(echo $RESULT | cut -d\| -f 3)

[ "$NAMESPACE" ] || exit 1
[ "$SERVICE" ] || exit 1
[ "$PORTS" ] || exit 1

POD=$( \
  kubectl get pods -n $NAMESPACE \
  | fzf --header-lines=1 -q $(echo $SERVICE | cut -d\| -f2) --prompt="Select a pod> "  | sed "s/ \{1,\}/|/g" | cut -d\| -f1
)
[ "$POD" ] || exit 1

PORTS_FORWARD=$(echo $PORTS | tr , '\n' | fzf -m --prompt="Select ports to forward (Tab for multi-select)> " | sed 's#[:/].*##g')
[ "$PORTS_FORWARD" ] || exit 1

PORT_PARAM=""
for PORT in $PORTS_FORWARD
do
  while :
  do
    >&2 echo -e -n "\e[32mForward $PORT to (Enter to use $PORT)> \e[0m"
    read PORT_FORWARD
    if [ -z "$PORT_FORWARD" ]
    then
      >&2 echo "Using $PORT"
      PORT_FORWARD=$PORT
      break
    elif $(echo $PORT_FORWARD | grep -q -E '^[0-9]+$')
    then
      break
    else
      >&2 echo " Please enter a valid port"
    fi
  done
  PORT_PARAM="$PORT_PARAM $PORT_FORWARD:$PORT"
done
[ "$PORT_PARAM" ] || exit 1

echo "kubectl port-forward $ADDRESS --namespace $NAMESPACE $POD$PORT_PARAM"
[ "$MODE" == "normal" ] && {
  kubectl port-forward $ADDRESS --namespace $NAMESPACE $POD$PORT_PARAM
}
