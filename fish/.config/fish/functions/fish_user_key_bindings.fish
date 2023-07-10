#!/usr/bin/env fish
function fish_user_key_bindings
  if status is-interactive
    fish_vi_key_bindings
    fzf_key_bindings
    custom_fzf_bindings
    auto_complete_mode
  end
end
