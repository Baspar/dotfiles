#!/usr/bin/env bash
MODE="normal"
for ARG in $*
do
  if [ "$ARG" == "--mock" ]
  then
    MODE="mock"
  fi
done

[ "$FZF_TMUX_HEIGHT" ] || {
  FZF_TMUX_HEIGHT=40%
}
export FZF_DEFAULT_OPTS="--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"

PROJECT=$(gcloud projects list | fzf --prompt="Select a project> "  | sed "s/ \{1,\}/|/g" | cut -d\| -f1)
[ "$PROJECT" ] || exit 1

CLUSTER_AND_ZONE=$( \
  gcloud container clusters list --project "$PROJECT" --format "table(name,location,endpoint,status,currentNodeCount)" \
  | fzf --prompt="Select a cluster> " | sed "s/ \{1,\}/|/g" | cut -d\| -f1,2
)
CLUSTER=$(echo "$CLUSTER_AND_ZONE" | cut -d\| -f1)
ZONE=$(echo "$CLUSTER_AND_ZONE" | cut -d\| -f2)
[ "$CLUSTER" ] || exit 1

echo "gcloud container clusters get-credentials $CLUSTER --project $PROJECT --zone $ZONE"
[ "$MODE" == "normal" ] && {
    gcloud container clusters get-credentials $CLUSTER --project $PROJECT --zone $ZONE
}
