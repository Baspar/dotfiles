#!/bin/bash
session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
tmux switch-client -t "$session"
