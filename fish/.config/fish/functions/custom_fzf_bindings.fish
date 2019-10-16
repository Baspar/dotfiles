function custom_fzf_bindings
  function fzf-docker -d "List docker id"
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    docker images | eval (__fzfcmd) | read -l result
      and commandline -i -- (echo $result | sed "s/ \{1,\}/|/g" | cut -d\| -f3)
      and commandline -f repaint
  end

  # Remove existing <C-x> mapping
  bind --erase --preset -M insert \cx fish_clipboard_copy
  bind --erase --preset \cx fish_clipboard_copy
  bind --erase --preset -M visual \cx fish_clipboard_copy

  if bind -M autocomplete > /dev/null 2>&1
    bind i   -M autocomplete --sets-mode insert force-repaint
    bind \cc -M autocomplete --sets-mode insert force-repaint
    bind \e  -M autocomplete --sets-mode insert force-repaint
    bind d   -M autocomplete --sets-mode insert fzf-docker
  end

  if bind -M insert > /dev/null 2>&1
    bind -M insert \cx --sets-mode autocomplete force-repaint
  end
end
