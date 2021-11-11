#!/usr/bin/env fish

# ========
# Settings
# ========

set -g FISH_SEPARATOR "$LEFT_SEPARATOR"
set -g FISH_SUB_SEPARATOR "$LEFT_SUB_SEPARATOR"
set -g ELLIPSIS "·"
set -g ELLIPSIS_AFTER "3"

# ========
# Mappings
# ========

bind -M insert \ce 'set -g __baspar_no_abbr ""; commandline -f repaint'
bind -M insert ' ' 'commandline -i " "; commandline -f expand-abbr; emit __baspar_check_special_command'
bind -M insert \c] 'emit __baspar_cycle_indicator'

# ==================
# Internal variables
# ==================

set -g __baspar_old_bg ""
set -g __baspar_fish_promp_count 0
set -g __baspar_fish_last_promp_count 0

# =======
# Helpers
# =======

function block -a BG FG TEXT
  # Same as _block, but wrap text with spaces
  #
  set FLAGS "$argv[4..-1]"

  _block "$BG" "$FG" " $TEXT " $FLAGS
end

function _block -a BG FG TEXT
  # Function _block
  #
  # @param BG: Background color of the block
  # @param FG: Foreground color of the block
  # @param TEXT: Text to display in the block
  # @param ...FLAGS: 0+ Flags for set_color
  #
  # @returns: A block with style and text
  #
  set FLAGS "$argv[4..-1]"

  [ -z $FLAGS ] || eval set_color $FLAGS

  if [ "$__baspar_old_bg" != "" ] && [ -z "$FISH_NO_POWERLINE" ]
    if [ "$__baspar_old_bg" = "$BG" ]
      set_color black -b $BG
      echo -n $FISH_SUB_SEPARATOR
    else
      set_color $__baspar_old_bg -b $BG
      echo -n $FISH_SEPARATOR
    end
  end

  if [ ! -z $TEXT ]
    set -g SKIP_ELLIPSIS 0
    set_color $FG -b $BG
    for TEXT_BLOCK in (echo "$TEXT" | tr "$ELLIPSIS" '\n')
      if [ $SKIP_ELLIPSIS  -ne 0 ]
        set_color '#666666' -b $BG
        echo -n "$ELLIPSIS"
        set_color $FG -b $BG
      end
      echo -n "$TEXT_BLOCK"
      set -g SKIP_ELLIPSIS 1
    end
  end
  set -g __baspar_old_bg $BG
  set_color normal -b normal
end

function __baspar_darker_of -a COLOR
  # Function __baspar_darker_of
  #
  # @param COLOR a color part of the list
  #
  # @returns: A darker shade of this color
  #
  if [ "$COLOR" = "#AF5F5E" ]
    echo -n "#703D3D"
  else if [ "$COLOR" = "#888888" ]
    echo -n "#555555"
  else if [ "$COLOR" = "#AF875F" ]
    echo -n "#926E49"
  else if [ "$COLOR" = "#4B8252" ]
    echo -n "#38623E"
  else
    echo -n ""
  end
end

# =============
# AWS indicator
# =============

function __baspar_cycle_indicator --on-event __baspar_cycle_indicator
  if set -q AWS_PROFILE && ! set -q __baspar_hide_aws
    set AWS_PROFILES (cat ~/.aws/credentials | sed '/^\[.*\]$/!d; s/\[\(.*\)\]/\1/')
    set count (count $AWS_PROFILES)
    set -g __baspar_aws_id (math $__baspar_aws_id % $count + 1)
    set -gx AWS_PROFILE $AWS_PROFILES[$__baspar_aws_id]
    commandline -f repaint
  end
end

function __baspar_aws_indicator_fn --on-event __baspar_aws_indicator
  set AWS_PROFILES ([ -f ~/.aws/credentials ] && cat ~/.aws/credentials | sed '/^\[.*\]$/!d; s/\[\(.*\)\]/\1/'); or return

  if ! set -q AWS_PROFILE
    set -g __baspar_aws_id 1
    set -gx AWS_PROFILE $AWS_PROFILES[$__baspar_aws_id]
  end

  set -e __baspar_hide_aws
  commandline -f repaint
end

function __baspar_check_special_command_fn --on-event __baspar_check_special_command
  switch (commandline | cut -d' ' -f1)
    case "aws"
      emit __baspar_aws_indicator
  end
end

function fish_custom_mode_prompt
  # Function fish_mode_prompt
  #
  # @returns Vi mode prompt
  #
  set LETTER ""

  # In SSH
  if set -q SSH_CLIENT
    set LETTER "$LETTER "
  else
    set LETTER "$LETTER "
  end

  # Root
  if [ (id -u) = "0" ]
    set LETTER "$LETTER "
  end

  # Vim mode
  switch $fish_bind_mode
    case "insert"
      set BG_COLOR "#AF875F"
    case "visual"
      set BG_COLOR "#AF5F5E"
    case "autocomplete"
      set BG_COLOR "#AF5F5E"
    case '*'
      set BG_COLOR "#FFFFFF"
  end

  _block "$BG_COLOR" "#000000" " $LETTER "
end

# =================
# Main prompt logic
# =================

function __baspar_abbr_path -a PATH_SEGMENT
  # Function __baspar_abbr_path
  #
  # @param PATH_SEGMENT a part of the PATH
  #
  # @returns: An abbreviated version of the PATH_SEGMENT (one letter, but keep prefix special characters)
  #           with $HOME replaced by ~
  #
  if set -q $__baspar_no_abbr
    echo -n "$PATH_SEGMENT" | sed "s#^$HOME#~#; s#\([^/]\{$ELLIPSIS_AFTER\}\)[^/]\{1,\}/#\1$ELLIPSIS/#g"
  else
    echo -n "$PATH_SEGMENT" | sed "s#^$HOME#~#"
  end
end

function __baspar_git_branch_name -a GIT_DIR GIT_WORKTREE
  # Function __baspar_git_branch_name
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns:
  #
  [ -d "$GIT_WORKTREE/rebase-merge" ] && {
    cat "$GIT_WORKTREE/rebase-merge/head-name" 2>/dev/null
    return
  }

  set x (git -C "$GIT_WORKTREE" symbolic-ref HEAD 2> /dev/null)
  if [ $status -eq 0 ]
    echo $x | \
      sed 's|refs/[^/]*/||g' | \
      tr -d '\n'
    return
  end

  echo (git -C "$GIT_WORKTREE" rev-parse HEAD | string match -r '^.{8}')…
end

function __baspar_git_operation -a GIT_DIR GIT_WORKTREE
  # Function __baspar_git_operation
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns: a symbol corresponding to the current operation
  #
  if test -d "$GIT_DIR/rebase-merge"
      set step (cat "$GIT_DIR/rebase-merge/msgnum" 2>/dev/null)
      set total (cat "$GIT_DIR/rebase-merge/end" 2>/dev/null)
      set GIT_OPERATION " "
  else if test -d "$GIT_DIR/rebase-apply"
    set step (cat "$GIT_DIR/rebase-apply/next" 2>/dev/null)
    set total (cat "$GIT_DIR/rebase-apply/last" 2>/dev/null)
    set GIT_OPERATION " "
  else if test -f "$GIT_DIR/MERGE_HEAD"
      set GIT_OPERATION " "
  else if test -f "$GIT_DIR/CHERRY_PICK_HEAD"
      set GIT_OPERATION " "
  else if test -f "$GIT_DIR/REVERT_HEAD"
      set GIT_OPERATION " "
  else if test -f "$GIT_DIR/BISECT_LOG"
      set GIT_OPERATION "÷"
  end

  if test -n "$step" -a -n "$total"
      set GIT_OPERATION "$GIT_OPERATION $step/$total"
  end

  echo "$GIT_OPERATION"
end

function __baspar_async_git_status -a GIT_DIR GIT_WORKTREE
  # Function __baspar_async_git_status
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns:
  #
  set -l changedFiles (command git -C "$GIT_WORKTREE" diff --name-status 2>/dev/null | string match -r \\w)
  set -l stagedFiles (command git -C "$GIT_WORKTREE" diff --staged --name-status | string match -r \\w)

  set -l dirtystate (math (count $changedFiles) - (count (string match -r "U" -- $changedFiles)))
  set -l invalidstate (count (string match -r "U" -- $stagedFiles))
  set -l stagedstate (math (count $stagedFiles) - $invalidstate)

  set -l untrackedfiles (command git -C "$GIT_WORKTREE" status --porcelain | grep "^??" | count)

  set exit_code 0
  [ $dirtystate -ge 1 ]     && set exit_code (math $exit_code + 1)
  [ $invalidstate -ge 1 ]   && set exit_code (math $exit_code + 2)
  [ $stagedstate -ge 1 ]    && set exit_code (math $exit_code + 4)
  [ $untrackedfiles -ge 1 ] && set exit_code (math $exit_code + 8)
  exit $exit_code
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
    command git -C "$GIT_WORKTREE" rev-list --count --left-right $GIT_UPSTREAM...HEAD 2>/dev/null | tr '\t' '|' | read -d '|' GIT_BEHIND GIT_AHEAD
  end

  echo "$GIT_HAS_UPSTREAM|$GIT_AHEAD|$GIT_BEHIND"
end

function __baspar_git_block_info -a GIT_DIR GIT_WORKTREE NEED_GIT_STATUS_UPDATE
  # Function __baspar_git_block_info
  #
  # @param GIT_DIR: Absolute path of the .git folder
  #
  # @returns: The color and status of the git information at given GIT_DIR
  #
  set SAFE_GIT_DIR (string escape --style=var "$GIT_DIR")

  __baspar_git_branch_name "$GIT_DIR" "$GIT_WORKTREE"  | read -l GIT_BRANCH
  __baspar_git_operation "$GIT_DIR" "$GIT_WORKTREE"    | read -l GIT_OPERATION
  __baspar_git_ahead_behind "$GIT_DIR" "$GIT_WORKTREE" | read -d '|' -l GIT_HAS_UPSTREAM GIT_AHEAD GIT_BEHIND

  # TODO: Use `string escape --style=var $GIT_DIR`
  if [ $NEED_GIT_STATUS_UPDATE ]
    if set -q __baspar_git_status_pid_$SAFE_GIT_DIR
      eval command kill -9 \$__baspar_git_status_pid_$SAFE_GIT_DIR 2>&1 > /dev/null
      eval functions -e __baspar_on_finish_git_status_\$__baspar_git_status_pid_$SAFE_GIT_DIR
    end

    command fish --private --command "__baspar_async_git_status '$GIT_DIR' '$GIT_WORKTREE'" &
    set -l pid (jobs --last --pid)
    set -g __baspar_git_status_pid_$SAFE_GIT_DIR $pid

    function __baspar_on_finish_git_status_$pid -V pid -V SAFE_GIT_DIR --on-process-exit $pid
      functions -e __baspar_on_finish_git_status_$pid

      if [ (eval echo \$__baspar_git_status_pid_$SAFE_GIT_DIR) = $pid ]
        set -e __baspar_git_status_pid_$SAFE_GIT_DIR
        set exit_code $argv[3]
        # Exit code 130 is given when <C-c> is pressed
        if [ $exit_code -lt 16 ]
          set -g __baspar_has_dirty_$SAFE_GIT_DIR (math "$exit_code % 2")
          set -g __baspar_has_invalid_$SAFE_GIT_DIR (math "floor($exit_code / 2) % 2")
          set -g __baspar_has_staged_$SAFE_GIT_DIR (math "floor($exit_code / 4) % 2")
          set -g __baspar_has_untracked_$SAFE_GIT_DIR (math "floor($exit_code / 8) % 2")
        end
        commandline -f repaint
      end
    end
  end

  # Default color
  set ICONS ""

  # Colors
  if [ -n "$GIT_OPERATION" ]
    set COLOR "#AF5F5E"
  else if ! set -q __baspar_has_dirty_$SAFE_GIT_DIR && ! set -q __baspar_has_untracked_$SAFE_GIT_DIR
    set COLOR "#888888"
  else if [ (eval echo \$__baspar_has_dirty_$SAFE_GIT_DIR) = "1" ] || [ (eval echo \$__baspar_has_untracked_$SAFE_GIT_DIR) = "1" ]
    set COLOR "#AF875F"
  else
    set COLOR "#4B8252"
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
  echo -n "$COLOR|$GIT_BRANCH|$GIT_OPERATION|$ICONS" | sed 's# $##'
end

function __baspar_cleanup --on-event fish_cancel
  # Function __baspar_cleanup
  #
  # Clean all indicators when C-c
  #
  set -g __baspar_hide_aws 'true'
end

function __baspar_set_fish_promp_count --on-event fish_prompt
  # Function __baspar_set_fish_promp_count
  #
  # Increment a counter for every "fresh" repaint and
  # cleanup some variable
  #
  set -g __baspar_fish_promp_count (math $__baspar_fish_promp_count + 1)
  set -g __baspar_hide_aws 'true'
  set -e __baspar_no_abbr
end

function __baspar_get_git_dir -a GIT_WORKTREE
  # Function __baspar_get_git_dir
  #
  # @param GIT_WORKTREE: root path of git worktree
  #
  # @returns: Actual location of the git config folder
  #
  if [ -f "$GIT_WORKTREE/.git" ]
    set GIT_DIR (cat "$GIT_WORKTREE/.git" | grep "^gitdir" | sed 's#^gitdir: *##')
    if ! string match -r "^/" "$GIT_DIR" &> /dev/null
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
  for PATH_SEGMENT in $__baspar_path_segments
    set -gx --append __baspar_path_segments_abbr (__baspar_abbr_path "$PATH_SEGMENT")
  end

  commandline -f repaint
end

function __baspar_update_path_segments --on-variable PWD
  # Function __baspar_update_path_segments
  #
  # Cache list of path segments
  #
  set -e __baspar_path_segments

  for PATH_SEGMENT in (echo $PWD | sed 's#^/##; s#/$##' | tr '/' '\n')
    set ACCUMULATED_PATH "$ACCUMULATED_PATH/$PATH_SEGMENT"
    if [ -e "$TOTAL_PATH$ACCUMULATED_PATH/.git" ]
      set -gx --append __baspar_path_segments "$ACCUMULATED_PATH"
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

function fish_prompt
  # Function fish_prompt
  #
  # @returns Main prompt
  #
  set -l _display_status $status

  set -g __baspar_old_bg ""

  # Command error status
  if [ "$_display_status" != "0" ]
    block "#AF5F5E" "#000000" "$_display_status" -o
  end

  # Virtual env
  if set -q VIRTUAL_ENV
    set VENV_NAME (basename $VIRTUAL_ENV)
    block "#4B8252" "#3e3e3e" "$VENV_NAME" -i -o
  end

  set NEED_GIT_STATUS_UPDATE ""
  if [ $__baspar_fish_promp_count -ne $__baspar_fish_last_promp_count ]
    set -g __baspar_fish_last_promp_count $__baspar_fish_promp_count
    set NEED_GIT_STATUS_UPDATE "true"
  end

  # Initialize path segment
  set -q __baspar_path_segments || __baspar_update_path_segments

  set TOTAL_PATH ''
  for i in (seq (count $__baspar_path_segments))
    set PATH_SEGMENT_ABBR $__baspar_path_segments_abbr[$i]
    set TOTAL_PATH $TOTAL_PATH$__baspar_path_segments[$i]

    # Path part block
    block "#3e3e3e" "#FFFFFF" "$PATH_SEGMENT_ABBR"

    # No git block for last part
    [ $i -eq (count $__baspar_path_segments) ] && break

    # Git block
    set GIT_WORKTREE "$TOTAL_PATH"
    set GIT_DIR (__baspar_get_git_dir "$GIT_WORKTREE")
    __baspar_git_block_info "$GIT_DIR" "$GIT_WORKTREE" "$NEED_GIT_STATUS_UPDATE" | read -d '|' GIT_BG_COLOR GIT_BRANCH GIT_OPERATION GIT_ICONS

    set GIT_FG_COLOR "#3e3e3e"
    set SAFE_GIT_DIR (string escape --style=var "$GIT_DIR")
    if set -q __baspar_git_status_pid_$SAFE_GIT_DIR
      set GIT_FG_COLOR "#666666"
    end

    [ -n "$GIT_OPERATION" ] && block (__baspar_darker_of $GIT_BG_COLOR) "#3e3e3e" "$GIT_OPERATION" -o -i
    block "$GIT_BG_COLOR" $GIT_FG_COLOR "$GIT_BRANCH" -o -i
    [ -n "$GIT_ICONS" ] && block (__baspar_darker_of $GIT_BG_COLOR) "#3e3e3e" "$GIT_ICONS" -o -i
  end

  _block "normal" "normal" ""
  echo ""

  set -g __baspar_old_bg ""
  fish_custom_mode_prompt
  _block "normal" "normal" ""
  echo " "
end

function fish_right_prompt
  set -g __baspar_old_bg "black"

  if set -q AWS_PROFILE && ! set -q __baspar_hide_aws
    set AWS_PROFILES (cat ~/.aws/credentials | sed '/^\[.*\]$/!d; s/\[\(.*\)\]/\1/')
    set count (count $AWS_PROFILES)
    block "#AF875F" "#000000" " $AWS_PROFILE" -o -i
    block (__baspar_darker_of "#AF875F") "#3e3e3e" "$__baspar_aws_id/$count" -o
  end
end

function fish_mode_prompt
  # Disable default Vi prompt
end
