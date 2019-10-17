function fish_user_key_bindings
  function __fzfcmd
    set -q FZF_TMUX; or set FZF_TMUX 0
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    if [ $FZF_TMUX -eq 1 ]
      echo "fzf-tmux -d$FZF_TMUX_HEIGHT $argv"
    else
      echo "fzf $argv"
    end
  end

  fish_vi_key_bindings
  fzf_key_bindings
  custom_fzf_bindings
  auto_complete_mode
end
