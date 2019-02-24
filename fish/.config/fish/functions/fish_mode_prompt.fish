function fish_mode_prompt

    if [ "$fish_bind_mode" = "insert" ]
        set LETTER "I"
        set COLOR "yellow"
    else if [ "$fish_bind_mode" = "visual" ]
        set LETTER "V"
        set COLOR "red"
    else
        set LETTER "N"
        set COLOR "white"
    end

    set_color "black" -b "$COLOR" -o
    echo -n " $LETTER "
    set_color "normal"
    set_color "$COLOR" -b "black"
    echo -n ""
end
