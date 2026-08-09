#!/usr/bin/env bash
case "$1" in
    light|dark)
         gsettings set org.gnome.desktop.interface color-scheme "prefer-$1"
         ;;
     *)
         echo "unexpected mode '$MODE'"
         ;;
esac
