#!/usr/bin/env bash
for CONF in ~/.tmuxinator/*
do
    NAME=$(echo "$CONF" | sed 's#^\(.*/\)*\([^/]*\)\.yaml$#\2#')
    echo "Starting $NAME"
    tmuxinator start "$NAME"
done
