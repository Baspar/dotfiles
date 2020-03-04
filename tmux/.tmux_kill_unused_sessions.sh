#!/usr/bin/env bash

SESSIONS_TO_KILL=$(tmux ls \
    | grep -e '^[0-9]\+:' \
    | grep -v '(attached)$' \
    | sed 's/:.*//g')


for SESSION in $SESSIONS_TO_KILL
do
    tmux kill-session -t $SESSION
done
