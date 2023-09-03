function set_colorscheme
  set -U prompt_green_bg "#4B8252"
  set -U prompt_green_bg_sec "#38623E"
  set -U prompt_green_fg "#3e3e3e"
  set -U prompt_green_fg_sec "#666666"

  set -U prompt_red_bg "#AF5F5E"
  set -U prompt_red_bg_sec "#703D3D"
  set -U prompt_red_fg "#3e3e3e"
  set -U prompt_red_fg_sec "#666666"

  set -U prompt_orange_bg "#AF875F"
  set -U prompt_orange_bg_sec "#926E49"
  set -U prompt_orange_fg "#3e3e3e"
  set -U prompt_orange_fg_sec "#666666"

  set -U prompt_inactive_bg "#888888"
  set -U prompt_inactive_bg_sec $prompt_inactive_bg
  set -U prompt_inactive_fg "#3e3e3e"
  set -U prompt_inactive_fg_sec $prompt_inactive_fg

  set -U prompt_bg "#3e3e3e"
  set -U prompt_bg_sec "#555555"
  set -U prompt_fg "#FFFFFF"
  set -U prompt_fg_sec "#888888"

  if [ "$THEME" = "Light" ]
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

    set -U prompt_green_bg "#859900"
    set -U prompt_green_bg_sec "#859900"
    set -U prompt_green_fg "#3e3e3e"
    set -U prompt_green_fg_sec "#666666"
    #
    # set -U prompt_red_bg "#AF5F5E"
    # set -U prompt_red_bg_sec "#703D3D"
    # set -U prompt_red_fg "#3e3e3e"
    # set -U prompt_red_fg_sec "#666666"

    set -U prompt_orange_bg "#bf9f7f"
    set -U prompt_orange_bg_sec "#a88b6d"
    set -U prompt_orange_fg "#3e3e3e"
    set -U prompt_orange_fg_sec "#666666"

    # set -U prompt_inactive_bg "#888888"
    # set -U prompt_inactive_bg_sec $prompt_inactive_bg
    # set -U prompt_inactive_fg "#3e3e3e"
    # set -U prompt_inactive_fg_sec $prompt_inactive_fg

    set -U prompt_bg "#ebdab4"
    set -U prompt_bg_sec "#555555"
    set -U prompt_fg "#4B3F36"
    set -U prompt_fg_sec "#aaaaaa"
  else
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
  end
end
