#!/usr/bin/env bash
# Based on https://github.com/wfxr/tmux-fzf-url
open_url() {
    if command -v xdg-open &>/dev/null; then
        nohup xdg-open "$@"
    elif command -v open &>/dev/null; then
        nohup open "$@"
    else
        echo "$@" | tmux loadb -w -
    fi
}

current_pane=$(tmux list-panes -F "#{pane_active}|#{scroll_position}|#{pane_height}" | grep "^1|")
scroll_position=$(echo "$current_pane" | cut -d\| -f2)
pane_height=$(echo "$current_pane" | cut -d\| -f3)
if [ -z "$scroll_position" ]; then
    content="$(tmux capture-pane -J -p)"
else
    content="$(tmux capture-pane -J -p -S -scroll_position -E $(( pane_height - scroll_position - 1)))"
fi

urls=$(echo "$content" | grep -noE '(https?|ftp|file):/?//[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]')
wwws=$(echo "$content" | grep -noE '(http?s://)?www\.[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]')
# ips=$(echo "$content" | grep -noE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(:[0-9]{1,5})?(/\S+)*' | sed 's/^\(.*\)$/http:\/\/\1/')
# gits=$(echo "$content" | grep -noE '(ssh://)?git@\S*' | sed 's/:/\//g' | sed 's/^\(ssh\/\/\/\)\{0,1\}git@\(.*\)$/https:\/\/\2/')

items=$(printf '%s\n' "$urls" "$wwws" "$ips" "$gits" |
    grep -v '^$' |
    sort -n |
    tac |
    sed 's/^[0-9]*://'
)

[ -z "$items" ] && tmux display 'tmux-fzf-url: no URLs found' && {
    exit
}

item=$(echo "$items" | fzf --no-preview --no-border) || exit 0

[ -n "$item" ] && open_url "$item" &> /dev/null
