function set_colorscheme
  if [ "$theme" = "Dark" ]
    set -U fish_color_autosuggestion 444444
    set -U fish_color_cancel normal
    set -U fish_color_command af5f00
    set -U fish_color_comment 9e9e9e
    set -U fish_color_cwd 008000
    set -U fish_color_cwd_root 800000
    set -U fish_color_end ff5f00
    set -U fish_color_error ff0000
    set -U fish_color_escape 00a6b2
    set -U fish_color_history_current normal
    set -U fish_color_host normal
    set -U fish_color_host_remote yellow
    set -U fish_color_match normal
    set -U fish_color_normal normal
    set -U fish_color_operator ffaf5f
    set -U fish_color_param ffd7af
    set -U fish_color_quote ffaf5f
    set -U fish_color_redirection ffd75f
    set -U fish_color_search_match --background=333
    set -U fish_color_selection c0c0c0
    set -U fish_color_status red
    set -U fish_color_user 00ff00
    set -U fish_color_valid_path normal
  else
    set -U fish_color_normal normal
    set -U fish_color_command af5f00
    set -U fish_color_quote ffaf00
    set -U fish_color_redirection d78700
    set -U fish_color_end ff5f00
    set -U fish_color_error ff0000
    set -U fish_color_param d78700
    set -U fish_color_comment 9e9e9e
    set -U fish_color_match normal
    set -U fish_color_selection c0c0c0
    set -U fish_color_search_match --background=333
    set -U fish_color_history_current normal
    set -U fish_color_operator ffaf5f
    set -U fish_color_escape 00a6b2
    set -U fish_color_cwd 008000
    set -U fish_color_cwd_root 800000
    set -U fish_color_valid_path normal
    set -U fish_color_autosuggestion 444444
    set -U fish_color_user 00ff00
    set -U fish_color_host normal
    set -U fish_color_cancel normal
    set -U fish_pager_color_background
    set -U fish_pager_color_prefix normal --bold --underline
    set -U fish_pager_color_progress brwhite --background=cyan
    set -U fish_pager_color_completion normal
    set -U fish_pager_color_description B3A06D
    set -U fish_pager_color_selected_background --background=brblack
    set -U fish_pager_color_selected_prefix
    set -U fish_pager_color_selected_completion
    set -U fish_pager_color_selected_description
    set -U fish_pager_color_secondary_background
    set -U fish_color_option
    set -U fish_pager_color_secondary_completion
    set -U fish_pager_color_secondary_description
    set -U fish_color_host_remote
    set -U fish_color_keyword
    set -U fish_pager_color_secondary_prefix
  end
end
