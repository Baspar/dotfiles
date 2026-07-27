#!/usr/bin/env fish

# ========
# Settings
# ========

set -g __baspar_separator "$LEFT_SEPARATOR"
set -g __baspar_sub_separator "$LEFT_SUB_SEPARATOR"

set -e __baspar_disable_transient_prompt
set -g __baspar_braille "⠀"

set -e __baspar_no_git
set -e __baspar_truncate_smart
set -g __baspar_truncate_after "3"

# ========
# Mappings
# ========

bind -M insert \ce 'set -g __baspar_no_abbr; commandline -f repaint'
bind -M insert \r transient_and_execute
bind \r transient_and_execute
bind -M insert \cc transient_and_cancel

# ================
# Transient prompt
# ================

function transient_and_execute
  if set -q __baspar_disable_transient_prompt
    commandline -f execute
    return
  end
  if commandline --is-valid || ! commandline | string length -q
    set -g __baspar_transient_prompt
    commandline --function repaint
    echo -en "\e[2K"
  end
  commandline -f execute
end

function transient_and_cancel
  if set -q __baspar_disable_transient_prompt
    commandline -f cancel-commandline repaint-mode
    return
  end
  if commandline | string length -q
    set -g __baspar_transient_prompt
    commandline -f repaint
    echo -en "\e[2K"
  end
  commandline -f cancel-commandline repaint-mode
end

# ==================
# Internal variables
# ==================

set -g __baspar_ellipsis_marker "·"
set -g __baspar_old_bg ""
set -g __baspar_fish_promp_count 0
set -g __baspar_fish_last_promp_count 0
set -g __baspar_need_git_update
set -e __baspar_no_abbr
set -e __baspar_transient_prompt

if [ (id -u) = "0" ]
  set -g __baspar_is_root
else
  set -e __baspar_is_root
end

# =======
# Helpers
# =======

function section -a BG FG TEXT
  # Same as _section, but wrap text with spaces
  #
  set FLAGS "$argv[4..-1]"

  _section "$BG" "$FG" " $TEXT " $FLAGS
end

function _section -a BG FG TEXT
  # Function _section
  # Will display section with style.
  # If `$__baspar_ellipsis_marker` is present, will style it with normal secondary FG
  #
  # @param BG: Background color of the section
  # @param FG: Foreground color of the section
  # @param TEXT: Text to display in the section
  # @param ...FLAGS: 0+ Flags for set_color
  #
  # @returns: A section with style and text
  #
  set FLAGS "$argv[4..-1]"

  [ -z $FLAGS ] || eval set_color $FLAGS

  if [ "$__baspar_old_bg" != "" ] && [ -z "$FISH_NO_POWERLINE" ]
    if [ "$__baspar_old_bg" = "$BG" ]
      set_color black -b $BG
      echo -n $__baspar_sub_separator
    else
      set_color $__baspar_old_bg -b $BG
      echo -n $__baspar_separator
    end
  end

  if [ ! -z $TEXT ]
    set_color $FG -b $BG
    set TEXT_BLOCKS (string split "$__baspar_ellipsis_marker" "$TEXT")
    set i 0
    for TEXT_BLOCK in $TEXT_BLOCKS
      set i (math $i + 1)
      if [ "$TEXT_BLOCK" ]
        if [ (math "$i % 2") -eq 0 ]
          set_color "$prompt_fg_sec" -b $BG -i
        else
          set_color $FG -b $BG
        end
        echo -n "$TEXT_BLOCK"
        set_color normal
      end
    end
  end
  set -g __baspar_old_bg $BG
  set_color normal -b normal
end

# =================
# Main prompt logic
# =================

function __baspar_abbr_path -a root path_segment
  # @param path_segment a part of the PATH
  #
  # @returns: An abbreviated version of the path_segment (one letter, but keep prefix special characters)
  #           with $HOME replaced by ~
  #

  # Replace a leading $HOME with
  if string match -q -- "$HOME*" "$path_segment"
    set path_segment "~"(string sub -s (math (string length -- "$HOME") + 1) -- "$path_segment")
  end

  if set -q __baspar_no_abbr
    echo -n "$path_segment"
    return
  end

  set segments (string split '/' -- (string trim -c '/' -- "$path_segment"))
  set segments_count (count $segments)
  set response ""
  set i 0
  for segment in $segments
    set i (math $i + 1)

    if [ $segment = "~" ] && [ -z $root ]
      set response "~"
      set root "$HOME"
    else
      if [ $i -eq $segments_count ]
        set truncated "$segment"
      else if set -q __baspar_truncate_smart
        set truncated ""
        for truncate_at in (seq $__baspar_truncate_after (string length "$segment"))
          set truncated (string sub --length $truncate_at $segment)
          [ (count $root/$truncated*/) -eq 1 ] && break
        end
      else
        set truncated (string sub --length $__baspar_truncate_after $segment)
      end

      set root $root"/"$segment
      if [ $truncated = $segment ]
        set response "$response/$segment"
      else
        set response "$response/$__baspar_ellipsis_marker$truncated$__baspar_ellipsis_marker"
      end
    end
  end
  echo -n "$response"
end

function __baspar_git_branch_name -a GIT_DIR GIT_WORKTREE
  # @param GIT_DIR location of .git folder
  #
  # @returns: The branch name, or commit hash
  #
  [ -d "$GIT_WORKTREE/rebase-merge" ] && {
  echo -n " "
  read -z head_name < "$GIT_WORKTREE/rebase-merge/head-name" 2>/dev/null
  echo -n (string replace -ra 'refs/[^/]*/' '' -- (string trim -- "$head_name"))
  return
  }

  # HEAD is on a branch
  set head_branch (git -C "$GIT_WORKTREE" symbolic-ref HEAD 2> /dev/null)
  if [ $status -eq 0 ]
    echo " $head_branch" | \
      string replace -ra 'refs/[^/]*/' '' | \
      string join ''
    return
  end

  # Detached HEAD
  echo " "(string sub -l 8 -- (git -C "$GIT_WORKTREE" rev-parse HEAD 2>/dev/null))
end

function __baspar_git_operation -a GIT_DIR GIT_WORKTREE
  # Function __baspar_git_operation
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns: a symbol corresponding to the current operation
  #
  if [ -d "$GIT_DIR/rebase-merge" ]
    read -z step < "$GIT_DIR/rebase-merge/msgnum" 2>/dev/null; set step (string trim -- "$step")
    read -z total < "$GIT_DIR/rebase-merge/end" 2>/dev/null; set total (string trim -- "$total")
    set GIT_OPERATION " "
  else if [ -d "$GIT_DIR/rebase-apply" ]
    read -z step < "$GIT_DIR/rebase-apply/next" 2>/dev/null; set step (string trim -- "$step")
    read -z total < "$GIT_DIR/rebase-apply/last" 2>/dev/null; set total (string trim -- "$total")
    set GIT_OPERATION " "
  else if [ -f "$GIT_DIR/MERGE_HEAD" ]
    set GIT_OPERATION " "
  else if [ -f "$GIT_DIR/CHERRY_PICK_HEAD" ]
    set GIT_OPERATION " "
  else if [ -f "$GIT_DIR/REVERT_HEAD" ]
    set GIT_OPERATION " "
  else if [ -f "$GIT_DIR/BISECT_LOG" ]
    set GIT_OPERATION "÷"
  end

  if [ -n "$step" ] && [ -n "$total" ]
    set GIT_OPERATION "$GIT_OPERATION $step/$total"
  end

  echo "$GIT_OPERATION"
end

function __baspar_git_ahead_behind -a GIT_DIR GIT_WORKTREE
  # Function __baspar_git_ahead_behind
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns:
  #
  set GIT_AHEAD 0
  set GIT_BEHIND 0
  set GIT_UPSTREAM (command git -C "$GIT_WORKTREE" rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)
  set GIT_HAS_UPSTREAM $status

  set GIT_BRANCH (command  git -C "$GIT_WORKTREE" rev-parse --abbrev-ref HEAD )
  if [ "$GIT_BRANCH" = "HEAD" ]
    set GIT_HAS_UPSTREAM 0
  end


  if [ -n $GIT_UPSTREAM ]
    command git -C "$GIT_WORKTREE" rev-list --count --left-right $GIT_UPSTREAM...HEAD 2>/dev/null | string replace \t '|' | read -d '|' GIT_BEHIND GIT_AHEAD
  end

  echo "$GIT_HAS_UPSTREAM|$GIT_AHEAD|$GIT_BEHIND"
end

function __baspar_git_section_info -a GIT_DIR GIT_WORKTREE
  # Function __baspar_git_section_info
  #
  # @param GIT_DIR: Absolute path of the .git folder
  #
  # @returns: The color and status of the git information at given GIT_DIR
  #
  set SAFE_GIT_DIR (string escape --style=var "$GIT_DIR")

  __baspar_git_branch_name "$GIT_DIR" "$GIT_WORKTREE"  | read -l GIT_BRANCH
  __baspar_git_operation "$GIT_DIR" "$GIT_WORKTREE"    | read -l GIT_OPERATION
  __baspar_git_ahead_behind "$GIT_DIR" "$GIT_WORKTREE" | read -d '|' -l GIT_HAS_UPSTREAM GIT_AHEAD GIT_BEHIND

  if set -q __baspar_need_git_update
    if set -q __baspar_git_status_pid_$SAFE_GIT_DIR
      eval command kill -9 \$__baspar_git_status_pid_$SAFE_GIT_DIR 2>&1 > /dev/null
      eval functions -e __baspar_on_finish_git_status_\$__baspar_git_status_pid_$SAFE_GIT_DIR
    end

    command fish --private --command "sleep 0.01 && __baspar_async_git_status '$GIT_DIR' '$GIT_WORKTREE'" 2>&1 > /dev/null &
    set -l pid (jobs --last --pid)
    set -g __baspar_git_status_pid_$SAFE_GIT_DIR $pid

    function __baspar_on_finish_git_status_$pid -V pid -V SAFE_GIT_DIR --on-process-exit $pid
      functions -e __baspar_on_finish_git_status_$pid

      if [ (eval echo \$__baspar_git_status_pid_$SAFE_GIT_DIR) = $pid ]
        set exit_code $argv[3]
        # Exit code 130 is given when <C-c> is pressed
        if [ $exit_code -lt 16 ]
          set -g __baspar_has_dirty_$SAFE_GIT_DIR (math "$exit_code % 2")
          set -g __baspar_has_invalid_$SAFE_GIT_DIR (math "floor($exit_code / 2) % 2")
          set -g __baspar_has_staged_$SAFE_GIT_DIR (math "floor($exit_code / 4) % 2")
          set -g __baspar_has_untracked_$SAFE_GIT_DIR (math "floor($exit_code / 8) % 2")
        end
      end
      set -e __baspar_git_status_pid_$SAFE_GIT_DIR
      commandline -f repaint
    end
  end

  # Default color
  set ICONS ""

  # Colors
  if [ -n "$GIT_OPERATION" ]
    set COLOR_BG "$prompt_red_bg"
    set COLOR_BG_SEC "$prompt_red_bg_sec"
    set COLOR_FG "$prompt_red_fg"
    set COLOR_FG_SEC "$prompt_red_fg_sec"
  else if ! set -q __baspar_has_dirty_$SAFE_GIT_DIR && ! set -q __baspar_has_untracked_$SAFE_GIT_DIR
    set COLOR_BG "$prompt_inactive_bg"
    set COLOR_BG_SEC "$prompt_inactive_bg_sec"
    set COLOR_FG "$prompt_inactive_fg"
    set COLOR_FG_SEC "$prompt_inactive_fg_sec"
  else if [ (eval echo \$__baspar_has_dirty_$SAFE_GIT_DIR) = "1" ] || [ (eval echo \$__baspar_has_untracked_$SAFE_GIT_DIR) = "1" ]
    set COLOR_BG "$prompt_orange_bg"
    set COLOR_BG_SEC "$prompt_orange_bg_sec"
    set COLOR_FG "$prompt_orange_fg"
    set COLOR_FG_SEC "$prompt_orange_fg_sec"
  else
    set COLOR_BG "$prompt_green_bg"
    set COLOR_BG_SEC "$prompt_green_bg_sec"
    set COLOR_FG "$prompt_green_fg"
    set COLOR_FG_SEC "$prompt_green_fg_sec"
  end

  # Icons
  set -q __baspar_has_staged_$SAFE_GIT_DIR    && [ (eval echo \$__baspar_has_staged_$SAFE_GIT_DIR) = "1" ]    && set ICONS "$ICONS+"
  set -q __baspar_has_dirty_$SAFE_GIT_DIR     && [ (eval echo \$__baspar_has_dirty_$SAFE_GIT_DIR) = "1" ]     && set ICONS "$ICONS~"
  set -q __baspar_has_untracked_$SAFE_GIT_DIR && [ (eval echo \$__baspar_has_untracked_$SAFE_GIT_DIR) = "1" ] && set ICONS "$ICONS?"

  # Left icons
  [ -n "$GIT_HAS_UPSTREAM" ] && [ $GIT_HAS_UPSTREAM -ne 0 ] && set GIT_OPERATION " $GIT_OPERATION"
  [ -n "$GIT_AHEAD"        ] && [ $GIT_AHEAD -ge 1        ] && set GIT_OPERATION "$GIT_OPERATION$GIT_AHEAD↑"
  [ -n "$GIT_BEHIND"       ] && [ $GIT_BEHIND -ge 1       ] && set GIT_OPERATION "$GIT_OPERATION$GIT_BEHIND↓"

  # Build git string
  echo -n (string replace -r ' $' '' -- "$COLOR_BG|$COLOR_BG_SEC|$COLOR_FG|$COLOR_FG_SEC|$GIT_BRANCH|$GIT_OPERATION|$ICONS")
end

function __baspar_reset --on-event fish_prompt --on-event fish_cancel
  # Function __baspar_reset
  #
  # Reset behaviour and variable
  # - Force git update
  # - Reset dir abbreviation
  # - Disable all indicators
  #
  set -g __baspar_need_git_update
  set -e __baspar_no_abbr
  set -e __baspar_transient_prompt
  for indicator in $__baspar_indicator_names
    set -e __baspar_indicator_show_$indicator
  end

  commandline -f repaint
end

function __baspar_get_git_dir -a GIT_WORKTREE
  # Function __baspar_get_git_dir
  #
  # @param GIT_WORKTREE: root path of git worktree
  #
  # @returns: Actual location of the git config folder
  #
  if [ -f "$GIT_WORKTREE/.git" ]
    read -z gitfile < "$GIT_WORKTREE/.git" 2>/dev/null
    set GIT_DIR (string replace -r '^gitdir: *' '' -- (string match -r '(?m)^gitdir:.*' -- "$gitfile") | string trim)
    if ! string match -qr "^/" -- "$GIT_DIR"
      set GIT_DIR "$GIT_WORKTREE/$GIT_DIR"
    end
  else
    set GIT_DIR "$GIT_WORKTREE/.git"
  end

  echo $GIT_DIR
end

function __baspar_update_path_segments_abbr --on-variable __baspar_no_abbr
  # Function __baspar_update_path_segments_abbr
  #
  # Cache list of abbreviated path segments
  #
  set -e __baspar_path_segments_abbr
  set ROOT ""
  for PATH_SEGMENT in $__baspar_path_segments
    set -g --append __baspar_path_segments_abbr (__baspar_abbr_path "$ROOT" "$PATH_SEGMENT")
    set ROOT $ROOT$PATH_SEGMENT
  end

  commandline -f repaint
end

function __baspar_update_path_segments --on-variable PWD
  # Function __baspar_update_path_segments
  #
  # Cache list of path segments
  #
  set -e __baspar_path_segments

  # When git blocks are disabled, show the whole path as a single segment
  if set -q __baspar_no_git
    set -g __baspar_path_segments "$PWD"
    __baspar_update_path_segments_abbr
    return
  end

  for PATH_SEGMENT in (string split '/' -- (string trim -c '/' -- "$PWD"))
    set ACCUMULATED_PATH "$ACCUMULATED_PATH/$PATH_SEGMENT"
    if [ -e "$TOTAL_PATH$ACCUMULATED_PATH/.git" ]
      set -g --append __baspar_path_segments "$ACCUMULATED_PATH"
      set TOTAL_PATH "$TOTAL_PATH$ACCUMULATED_PATH"
      set ACCUMULATED_PATH ''
    end
  end

  [ -z "$ACCUMULATED_PATH" ] && set ACCUMULATED_PATH '/'

  set -g --append __baspar_path_segments "$ACCUMULATED_PATH"

  __baspar_update_path_segments_abbr
end

# =======
# Prompts
# =======

function fish_custom_mode_prompt
  # Function fish_mode_prompt
  #
  # @returns Vi mode prompt
  #
  set LETTER ""

  # In SSH
  if [ $SSH_CLIENT ]
    set LETTER "$LETTER "
  else
    set LETTER "$LETTER "
  end

  # Root
  if set -q __baspar_is_root
    set LETTER "$LETTER "
  end

  # Vim mode
  switch $fish_bind_mode
    case "insert"
      set BG_COLOR "$prompt_orange_bg"
      set FG_COLOR "$prompt_orange_fg"
    case "visual"
      set BG_COLOR "$prompt_red_bg"
      set FG_COLOR "$prompt_red_fg"
    case "autocomplete"
      set BG_COLOR "$prompt_green_bg"
      set FG_COLOR "$prompt_green_fg"
    case '*'
      set BG_COLOR "$prompt_inactive_bg"
      set FG_COLOR "$prompt_inactive_fg"
  end

  _section "$BG_COLOR" "$FG_COLOR" " $LETTER "
end

function fish_transient_prompt
  set TOTAL_PATH ''

  set segments_count (count $__baspar_path_segments)
  set i 0
  for PATH_SEGMENT in $__baspar_path_segments
    set i (math $i + 1)
    set PATH_SEGMENT_ABBR $__baspar_path_segments_abbr[$i]
    set TOTAL_PATH $TOTAL_PATH$PATH_SEGMENT

    section "$prompt_bg" "$prompt_fg" "$PATH_SEGMENT_ABBR"

    # No git section for last part
    [ $i -eq $segments_count ] && break

    # Git section (skippable via __baspar_no_git)
    set -q __baspar_no_git && continue
    set GIT_DIR (__baspar_get_git_dir "$TOTAL_PATH")
    set SAFE_GIT_DIR (string escape --style=var "$GIT_DIR")
    __baspar_git_section_info "$GIT_DIR" "$TOTAL_PATH" \
      | read -d '|' GIT_BG_COLOR GIT_BG_COLOR_SEC GIT_FG_COLOR GIT_FG_COLOR_SEC GIT_BRANCH GIT_OPERATION GIT_ICONS

    if [ -n "$GIT_OPERATION" ]
      section "$GIT_BG_COLOR_SEC" "$GIT_FG_COLOR" "$GIT_OPERATION" -o -i
    else
      section "$GIT_BG_COLOR" "$GIT_FG_COLOR" (echo "$GIT_BRANCH" | head -c 3) -o -i
    end
  end
  _section "normal" "normal" ""
  echo "$__baspar_braille"
end

function fish_prompt
  # Function fish_prompt
  #
  # @returns Main prompt
  #
  set _display_status $status

  __baspar_indicator_init

  set -g __baspar_old_bg ""

  # Initialize path segment
  set -q __baspar_path_segments || __baspar_update_path_segments

  if set -q __baspar_transient_prompt
    fish_transient_prompt
    return
  end

  # Command error status
  if [ "$_display_status" != "0" ]
    section "$prompt_red_bg" "$prompt_red_fg" "$_display_status" -o
  end

  # Virtual env
  if [ $VIRTUAL_ENV ]
    set VENV_NAME (basename $VIRTUAL_ENV)
    section "$prompt_green_bg" "$prompt_green_fg" "$VENV_NAME" -i -o
  end

  set TOTAL_PATH ''
  set segments_count (count $__baspar_path_segments)
  set i 0
  for PATH_SEGMENT in $__baspar_path_segments
    set i (math $i + 1)
    set PATH_SEGMENT_ABBR $__baspar_path_segments_abbr[$i]
    set TOTAL_PATH $TOTAL_PATH$PATH_SEGMENT

    # Path part section
    section "$prompt_bg" "$prompt_fg" "$PATH_SEGMENT_ABBR"

    # No git section for last part
    [ $i -eq $segments_count ] && break

    # Git section (skippable via __baspar_no_git)
    set -q __baspar_no_git && continue
    set GIT_DIR (__baspar_get_git_dir "$TOTAL_PATH")
    set SAFE_GIT_DIR (string escape --style=var "$GIT_DIR")
    __baspar_git_section_info "$GIT_DIR" "$TOTAL_PATH" \
      | read -d '|' GIT_BG_COLOR GIT_BG_COLOR_SEC GIT_FG_COLOR GIT_FG_COLOR_SEC GIT_BRANCH GIT_OPERATION GIT_ICONS

    # Assign git Foreground color if job running or not
    if set -q __baspar_git_status_pid_$SAFE_GIT_DIR
      set GIT_FG_COLOR "$GIT_FG_COLOR_SEC"
    end

    [ -n "$GIT_OPERATION" ] && section "$GIT_BG_COLOR_SEC" "$GIT_FG_COLOR" "$GIT_OPERATION" -o -i
    section "$GIT_BG_COLOR" "$GIT_FG_COLOR" "$GIT_BRANCH" -o -i
    [ -n "$GIT_ICONS" ] && section "$GIT_BG_COLOR_SEC" "$GIT_FG_COLOR" "$GIT_ICONS" -o -i
  end

  _section "normal" "normal" ""
  echo ""

  set -g __baspar_old_bg ""
  fish_custom_mode_prompt
  _section "normal" "normal" " "

  set -e __baspar_need_git_update
end

function fish_right_prompt
  set -g __baspar_old_bg "black"

  __baspar_indicator_display
end

function fish_mode_prompt
  # Disable default Vi prompt
end
