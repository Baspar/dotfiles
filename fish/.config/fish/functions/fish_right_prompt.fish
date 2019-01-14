function fish_right_prompt
    set_color black
    date +%H:%M:%S | tr -d '\n'
    set_color normal
end
