function fish_mode_prompt
    if [ "$fish_bind_mode" = "insert" ]
        print_in normal black "░▒▓"
    else if [ "$fish_bind_mode" = "visual" ]
        print_in black white "▒░ "
    else
        print_in normal black "▓▓▓"
    end
end
