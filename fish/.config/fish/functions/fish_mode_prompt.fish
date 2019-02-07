function fish_mode_prompt
    set_color "black" -b "yellow" -o
    if [ "$fish_bind_mode" = "insert" ]
        echo -n " I "
    else if [ "$fish_bind_mode" = "visual" ]
        echo -n " V "
    else
        echo -n " N "
    end

    set_color "normal"
    set_color "yellow" -b "black"
    echo -n ""
end
