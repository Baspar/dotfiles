#!/usr/bin/env fish
function fish_mode_prompt
    if [ "$fish_bind_mode" = "insert" ]
        set LETTER "I"
        set COLOR "#AF875F"
    else if [ "$fish_bind_mode" = "visual" ]
        set LETTER "V"
        set COLOR "#AF5F5E"
    else if [ "$fish_bind_mode" = "autocomplete" ]
        set LETTER "X"
        set COLOR "#AF5F5E"
    else
        set LETTER "N"
        set COLOR "white"
    end

    set_color "black" -b "$COLOR" -o
    echo -n " $LETTER "
    set_color "normal"
    set_color "$COLOR" -b "#3e3e3e"
    echo -n ""
end
