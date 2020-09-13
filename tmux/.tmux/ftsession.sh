#!/bin/bash
session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --exit-0)

if [ $? -ne 0 ]; then exit; fi
tmux switch-client -t "$session"
