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

echo "gcloud config set project '$PROJECT'"
[ "$MODE" == "normal" ] && {
  gcloud config set project "$PROJECT"
}
