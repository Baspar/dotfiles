#!/usr/bin/env fish

# Settings
set -g FISH_SEPARATOR "$LEFT_SEPARATOR"
set -g FISH_SUB_SEPARATOR "$LEFT_SUB_SEPARATOR"
set -g ELLIPSIS "·"
set -g ELLIPSIS_AFTER "3"

# Mappings
bind -M insert \ce 'set -g __baspar_no_abbr "true"; commandline -f repaint'

# Internal variables
set -g __baspar_no_abbr ''
set -g __baspar_old_bg ""
set -g __baspar_fish_promp_count 0
set -g __baspar_fish_last_promp_count 0
set -g __baspar_has_dirty -1
set -g __baspar_has_invalid -1
set -g __baspar_has_staged -1
set -g __baspar_has_untracked -1
# set -g __baspar_git_status_pid -1

function block
  # Same as _block, but wrap text with spaces
  set BG "$argv[1]"
  set FG "$argv[2]"
  set TEXT "$argv[3]"
  set FLAGS "$argv[4..-1]"

  _block "$BG" "$FG" " $TEXT " $FLAGS
end

function _block
  # Function _block
  #
  # @param BG: Background color of the block
  # @param FG: Foreground color of the block
  # @param TEXT: Text to display in the block
  # @param ...FLAGS: 0+ Flags for set_color
  #
  # @returns: A block with style and text

  set BG "$argv[1]"
  set FG "$argv[2]"
  set TEXT "$argv[3]"
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

function fish_mode_prompt
  # Disable default Vi prompt
end

function fish_custom_mode_prompt
  # Function fish_mode_prompt
  #
  # @returns Vi mode prompt
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

  if [ "$fish_bind_mode" = "insert" ]
    set COLOR "#AF875F"
  else if [ "$fish_bind_mode" = "visual" ]
    set COLOR "#AF5F5E"
  else if [ "$fish_bind_mode" = "autocomplete" ]
    set COLOR "#AF5F5E"
  else
    set COLOR "#FFFFFF"
  end

  _block "$COLOR" "#000000" " $LETTER "
end

function __baspar_abbr_path
  # Function __baspar_abbr_path
  #
  # @param PATH_PART a part of the PATH
  #
  # @returns: An abbreviated version of the PATH_PART (one letter, but keep prefix special characters)
  #           with $HOME replaced by ~

  if [ -z $__baspar_no_abbr ]
    echo -n $argv | sed "s#^$HOME#~#; s#\([^/]\{$ELLIPSIS_AFTER\}\)[^/]\{1,\}/#\1$ELLIPSIS/#g"
  else
    echo -n $argv | sed "s#^$HOME#~#"
  end
end

function __baspar_darker_of
  # Function __baspar_darker_of
  #
  # @param COLOR a color part of the list
  #
  # @returns: A darker shade of this color

  if [ "$argv" = "#AF5F5E" ]
    echo -n "#703D3D"
  else if [ "$argv" = "#AF875F" ]
    echo -n "#926E49"
  else if [ "$argv" = "#4B8252" ]
    echo -n "#38623E"
  else
    echo -n ""
  end
end


function __baspar_git_branch_name
  # Function __baspar_git_branch_name
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns:
  echo $argv | read -d ' ' -l GIT_CONFIG GIT_WORKTREE

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

function __baspar_git_operation
  # Function __baspar_git_operation
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns: a symbol corresponding to the current operation
  echo $argv | read -d ' ' -l GIT_CONFIG GIT_WORKTREE

  if test -d "$GIT_CONFIG/rebase-merge"
      set step (cat "$GIT_CONFIG/rebase-merge/msgnum" 2>/dev/null)
      set total (cat "$GIT_CONFIG/rebase-merge/end" 2>/dev/null)
      set GIT_OPERATION " "
  else if test -d "$GIT_CONFIG/rebase-apply"
    set step (cat "$GIT_CONFIG/rebase-apply/next" 2>/dev/null)
    set total (cat "$GIT_CONFIG/rebase-apply/last" 2>/dev/null)
    set GIT_OPERATION " "
  else if test -f "$GIT_CONFIG/MERGE_HEAD"
      set GIT_OPERATION " "
  else if test -f "$GIT_CONFIG/CHERRY_PICK_HEAD"
      set GIT_OPERATION " "
  else if test -f "$GIT_CONFIG/REVERT_HEAD"
      set GIT_OPERATION " "
  else if test -f "$GIT_CONFIG/BISECT_LOG"
      set GIT_OPERATION "÷"
  end

  if test -n "$step" -a -n "$total"
      set GIT_OPERATION "$GIT_OPERATION $step/$total"
  end

  echo "$GIT_OPERATION"
end

function __baspar_git_status
  # Function __baspar_git_status
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns:
  echo $argv | read -d ' ' -l GIT_DIR GIT_WORKTREE

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

function __baspar_git_ahead_behind
  # Function __baspar_git_ahead_behind
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns:
  echo $argv | read -d ' ' -l GIT_DIR GIT_WORKTREE

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

function __baspar_git_block_info
  # Function __baspar_git_block_info
  #
  # @param GIT_CONFIG: Absolute path of the .git folder
  #
  # @returns: The color and status of the git information at given GIT_DIR

  echo $argv | read -d ' ' -l GIT_DIR GIT_WORKTREE NEED_GIT_STATUS_UPDATE

  __baspar_git_branch_name "$GIT_DIR" "$GIT_WORKTREE"  | read -l GIT_BRANCH
  __baspar_git_operation "$GIT_DIR" "$GIT_WORKTREE"    | read -l GIT_OPERATION
  __baspar_git_ahead_behind "$GIT_DIR" "$GIT_WORKTREE" | read -d '|' -l GIT_HAS_UPSTREAM GIT_AHEAD GIT_BEHIND

  # TODO: Use `string escape --style=var $GIT_DIR`
  if [ $NEED_GIT_STATUS_UPDATE ]
    if set -q __baspar_git_status_pid
      command kill -9 $__baspar_git_status_pid 2>&1 > /dev/null
      functions -e __baspar_on_finish_git_status_$__baspar_git_status_pid
    end

    command fish --private --command "__baspar_git_status '$GIT_DIR' '$GIT_WORKTREE'" &
    set -l pid (jobs --last --pid)
    set -g __baspar_git_status_pid $pid

    function __baspar_on_finish_git_status_$pid --inherit-variable pid --on-process-exit $pid
      functions -e __baspar_on_finish_git_status_$pid

      if [ $pid -eq $__baspar_git_status_pid ]
        set -g -e __baspar_git_status_pid
        set exit_code $argv[3]
        set -g __baspar_has_dirty (math "$exit_code % 2")
        set -g __baspar_has_invalid (math "floor($exit_code / 2) % 2")
        set -g __baspar_has_staged (math "floor($exit_code / 4) % 2")
        set -g __baspar_has_untracked (math "floor($exit_code / 8) % 2")
        commandline -f repaint
      end
    end
  end

  # Default color
  set ICONS ""

  # Colors
  if [ -n "$GIT_OPERATION" ]
    set COLOR "#AF5F5E"
  else if [ $__baspar_has_dirty -eq 1 ] || [ $__baspar_has_untracked -eq 1 ]
    set COLOR "#AF875F"
  else
    set COLOR "#4B8252"
  end

  # Icons
  [ $__baspar_has_staged -eq 1    ] && set ICONS "$ICONS+"
  [ $__baspar_has_dirty -eq 1     ] && set ICONS "$ICONS~"
  [ $__baspar_has_untracked -eq 1 ] && set ICONS "$ICONS?"

  # Left icons
  [ -n "$GIT_HAS_UPSTREAM" ] && [ $GIT_HAS_UPSTREAM -ne 0 ] && set GIT_OPERATION " $GIT_OPERATION"
  [ -n "$GIT_AHEAD"        ] && [ $GIT_AHEAD -ge 1        ] && set GIT_OPERATION "$GIT_OPERATION$GIT_AHEAD↑"
  [ -n "$GIT_BEHIND"       ] && [ $GIT_BEHIND -ge 1       ] && set GIT_OPERATION "$GIT_OPERATION$GIT_BEHIND↓"

  # Build git string
  echo -n "$COLOR|$GIT_BRANCH|$GIT_OPERATION|$ICONS" | sed 's# $##'
end

function __baspar_set_fish_promp_count --on-event fish_prompt
  set -g __baspar_fish_promp_count (math $__baspar_fish_promp_count + 1)
end

function fish_prompt
  # Function fish_prompt
  #
  # @returns Main prompt

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

  set TOTAL_PATH ''
  set ACCUMULATED_PATH ''

  set NEED_GIT_STATUS_UPDATE ""
  if [ $__baspar_fish_promp_count -ne $__baspar_fish_last_promp_count ]
    set -g __baspar_fish_last_promp_count $__baspar_fish_promp_count
    set NEED_GIT_STATUS_UPDATE "true"
  end

  for PWD_PART in (echo $PWD | sed 's#^/##; s#/$##' |  tr '/' '\n')
    set ACCUMULATED_PATH "$ACCUMULATED_PATH/$PWD_PART"
    if [ -e "$TOTAL_PATH$ACCUMULATED_PATH/.git" ]
      set GIT_WORKTREE "$TOTAL_PATH$ACCUMULATED_PATH"
      if [ -f "$GIT_WORKTREE/.git" ]
        set GIT_CONFIG (cat "$GIT_WORKTREE/.git" | grep "^gitdir" | sed 's#^gitdir: *##')
        if ! string match -r "^/" "$GIT_CONFIG" &> /dev/null
          set GIT_CONFIG "$GIT_WORKTREE/$GIT_CONFIG"
        end
      else
        set GIT_CONFIG "$GIT_WORKTREE/.git"
      end

      __baspar_git_block_info "$GIT_CONFIG" "$GIT_WORKTREE" "$NEED_GIT_STATUS_UPDATE" | read -d '|' GIT_BG_COLOR GIT_BRANCH GIT_OPERATION GIT_ICONS

      set TOTAL_PATH "$TOTAL_PATH$ACCUMULATED_PATH"

      set ACCUMULATED_PATH (__baspar_abbr_path "$ACCUMULATED_PATH")
      block "#3e3e3e" "#FFFFFF" "$ACCUMULATED_PATH"

      set GIT_FG_COLOR "#3e3e3e"
      if [ "$__baspar_git_status_pid" ]
        set GIT_FG_COLOR "#666666"
      end

      [ -n "$GIT_OPERATION" ] && block (__baspar_darker_of $GIT_BG_COLOR)  "#3e3e3e" "$GIT_OPERATION" -o -i
      block "$GIT_BG_COLOR" $GIT_FG_COLOR "$GIT_BRANCH" -o -i
      [ -n "$GIT_ICONS" ] && block (__baspar_darker_of $GIT_BG_COLOR) "#3e3e3e" "$GIT_ICONS" -o -i

      set ACCUMULATED_PATH ''
    end
  end

  [ "$ACCUMULATED_PATH" ] || set ACCUMULATED_PATH '/'
  set ACCUMULATED_PATH (__baspar_abbr_path "$ACCUMULATED_PATH")

  block "#3e3e3e" "#FFFFFF" "$ACCUMULATED_PATH"

  _block "normal" "normal" ""
  echo ""

  set -g __baspar_old_bg ""
  fish_custom_mode_prompt
  _block "normal" "normal" ""
  echo " "

  if ! [ -z __baspar_no_abbr ]
    set -g __baspar_no_abbr ''
  end
end
