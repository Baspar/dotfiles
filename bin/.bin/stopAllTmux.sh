#!/usr/bin/env bash
for CONF in ~/.tmuxinator/*
do
    NAME=$(echo "$CONF" | sed 's#^\(.*/\)*\([^/]*\)\.yaml$#\2#')
    echo "Stopping $NAME"
    tmuxinator stop "$NAME"
done
