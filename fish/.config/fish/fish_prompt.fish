#!/usr/bin/env fish

set -g FISH_SEPARATOR "$LEFT_SEPARATOR"
set -g FISH_SUB_SEPARATOR "$LEFT_SUB_SEPARATOR"
set -g OLD_BG ""
set -g ELLIPSIS "·"
set -g ELLIPSIS_AFTER "3"
set -g CR_AFTER_GIT 0
set -g NO_UNTRACKED 0

function block
  # Function block
  #
  # @param BG: Background color of the block
  # @param FG: Foreground color of the block
  # @param ...TEXT: Text to display in the block
  #
  # @returns: A block with style and text

  echo $argv | read -d ' ' -l BG FG TEXT

  if [ "$OLD_BG" != "" ] && [ -z "$FISH_NO_POWERLINE" ]
    if [ "$OLD_BG" = "$BG" ]
      set_color black -b $BG
      echo -n $FISH_SUB_SEPARATOR
    else
      set_color $OLD_BG -b $BG
      echo -n $FISH_SEPARATOR
    end
  end

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
  set -g OLD_BG $BG
  set_color normal -b normal
end

function fish_mode_prompt
  # Disable default Vi prompt
end

function fish_mode_prompt_2
  # Function fish_mode_prompt
  #
  # @returns Vi mode prompt

  if [ "$fish_bind_mode" = "insert" ]
    set LETTER "I"
    set COLOR "#AF875F"
  else if [ "$fish_bind_mode" = "visual" ]
    set LETTER "V"
    set COLOR "#AF5F5E"
  else if [ "$fish_bind_mode" = "autocomplete" ]
    set LETTER "X"
    set COLOR "#AF5F5E"
  else
    set LETTER "N"
    set COLOR "#FFFFFF"
  end

  block "$COLOR" "#000000" " $LETTER "
end


function abbr_path
  # Function abbr_path
  #
  # @param PATH_PART a part of the PATH
  #
  # @returns: An abbreviated version of the PATH_PART (one letter, but keep prefix special characters)
  #           with $HOME replaced by ~

  echo -n $argv | sed "s#^$HOME#~#; s#\([^/]\{$ELLIPSIS_AFTER\}\)[^/]\{1,\}/#\1$ELLIPSIS/#g"
end

function darker_of
  # Function darker_of
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


function git_branch_name
  # Function git_branch_name
  #
  # @param GIT_ROOT location of .git folder
  #
  # @returns:
  echo $argv | read -d ' ' -l GIT_ROOT

  [ -d "$GIT_ROOT/rebase-merge" ] && {
    cat "$GIT_ROOT/rebase-merge/head-name" 2>/dev/null
    return
  }

  set x (git -C "$GIT_ROOT" symbolic-ref HEAD 2> /dev/null)
  if [ $status -eq 0 ]
    echo $x | \
      sed 's|refs/[^/]*/||g' | \
      tr -d '\n'
    return
  end

  echo (git -C "$GIT_ROOT" rev-parse HEAD | string match -r '^.{8}')…
end

function git_operation
  # Function git_operation
  #
  # @param GIT_ROOT location of .git folder
  #
  # @returns: a symbol corresponding to the current operation
  set GIT_ROOT $argv/.git

  if test -d $GIT_ROOT/rebase-merge
      set step (cat $GIT_ROOT/rebase-merge/msgnum 2>/dev/null)
      set total (cat $GIT_ROOT/rebase-merge/end 2>/dev/null)
      set GIT_OPERATION " "
  else if test -d $GIT_ROOT/rebase-apply
    set step (cat $GIT_ROOT/rebase-apply/next 2>/dev/null)
    set total (cat $GIT_ROOT/rebase-apply/last 2>/dev/null)
    set GIT_OPERATION " "
  else if test -f $GIT_ROOT/MERGE_HEAD
      set GIT_OPERATION " "
  else if test -f $GIT_ROOT/CHERRY_PICK_HEAD
      set GIT_OPERATION " "
  else if test -f $GIT_ROOT/REVERT_HEAD
      set GIT_OPERATION " "
  else if test -f $GIT_ROOT/BISECT_LOG
      set GIT_OPERATION "÷"
  end

  if test -n "$step" -a -n "$total"
      set GIT_OPERATION "$GIT_OPERATION $step/$total"
  end

  echo $GIT_OPERATION
end

function git_status
  # Function git_status
  #
  # @param GIT_ROOT location of .git folder
  #
  # @returns:
  echo $argv | read -d ' ' -l GIT_ROOT

  # set -l GIT_STATUS (command git -C "$GIT_ROOT" status --porcelain)

  set -l changedFiles (command git -C "$GIT_ROOT" diff --name-status 2>/dev/null | string match -r \\w)
  set -l stagedFiles (command git -C "$GIT_ROOT" diff --staged --name-status | string match -r \\w)

  set -l dirtystate (math (count $changedFiles) - (count (string match -r "U" -- $changedFiles)))
  set -l invalidstate (count (string match -r "U" -- $stagedFiles))
  set -l stagedstate (math (count $stagedFiles) - $invalidstate)
  if [ $NO_UNTRACKED -eq 0 ]
    set untrackedfiles (command git -C "$GIT_ROOT" ls-files --others --exclude-standard :/ --directory --no-empty-directory | count)
  else
    set untrackedfiles 0
  end

  echo "$dirtystate|$invalidstate|$stagedstate|$untrackedfiles"
end

function git_ahead_behind
  # Function git_ahead_behind
  #
  # @param GIT_ROOT location of .git folder
  #
  # @returns:
  echo $argv | read -d ' ' -l GIT_ROOT

  set GIT_AHEAD 0
  set GIT_BEHIND 0
  set GIT_UPSTREAM (command git -C "$GIT_ROOT" rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)

  if [ -n $GIT_UPSTREAM ]
    command git -C "$GIT_ROOT" rev-list --count --left-right $GIT_UPSTREAM...HEAD 2>/dev/null | tr '\t' '|' | read -d '|' GIT_BEHIND GIT_AHEAD 
  end

  echo "$GIT_AHEAD|$GIT_BEHIND"
end

function git_block_info
  # Function git_block_info
  #
  # @param GIT_CONFIG: Absolute path of the .git folder
  #
  # @returns: The color and status of the git information at given GIT_ROOT

  echo $argv | read -d ' ' -l GIT_ROOT

  git_branch_name "$GIT_ROOT"  | read -d '|' -l GIT_BRANCH
  git_operation "$GIT_ROOT"    | read -d '|' -l GIT_OPERATION
  git_status "$GIT_ROOT"       | read -d '|' -l GIT_DIRTY GIT_INVALID GIT_STAGED GIT_UNTRACKED
  git_ahead_behind "$GIT_ROOT" | read -d '|' -l GIT_AHEAD GIT_BEHIND

  # Default color
  set ICONS ""

  # Colors
  if [ -n "$GIT_OPERATION" ]
    set COLOR "#AF5F5E"
  else if [ $GIT_DIRTY -ge 1 ] || [ $GIT_UNTRACKED -ge 1 ]
    set COLOR "#AF875F"
  else
    set COLOR "#4B8252"
  end

  # Icons
  [ -n "$GIT_STAGED"    ] && [ $GIT_STAGED -ge 1    ] && set ICONS "$ICONS+"
  [ -n "$GIT_DIRTY"     ] && [ $GIT_DIRTY -ge 1     ] && set ICONS "$ICONS~"
  [ -n "$GIT_UNTRACKED" ] && [ $GIT_UNTRACKED -ge 1 ] && set ICONS "$ICONS?"

  # Left icons
  [ -n "$GIT_AHEAD"     ] && [ $GIT_AHEAD -ge 1     ] && set GIT_OPERATION "$GIT_OPERATION$GIT_AHEAD↑"
  [ -n "$GIT_BEHIND"    ] && [ $GIT_BEHIND -ge 1    ] && set GIT_OPERATION "$GIT_OPERATION$GIT_BEHIND↓"

  # Build git string
  echo -n "$COLOR|$GIT_BRANCH|$GIT_OPERATION|$ICONS" | sed 's# $##'
end

function fish_prompt
  # Function fish_prompt
  #
  # @returns Main prompt

  set -l _display_status $status

  set -g OLD_BG ""

  if [ "$_display_status" != "0" ]
    set_color -o
    block "#AF5F5E" "#000000" " $_display_status "
  end

  # Virtual env
  if set -q VIRTUAL_ENV
    set VENV_NAME (basename $VIRTUAL_ENV)
    block "#4B8252" "#000000" " $VENV_NAME "
  end

  set TOTAL_PATH ''
  set ACCUMULATED_PATH ''

  for PWD_PART in (echo $PWD | sed 's#^/##; s#/$##' |  tr '/' '\n')
    set ACCUMULATED_PATH "$ACCUMULATED_PATH/$PWD_PART"
    if [ -e "$TOTAL_PATH$ACCUMULATED_PATH/.git" ]
      if [ -f "$TOTAL_PATH$ACCUMULATED_PATH/.git" ]
        set GIT_CONFIG (cat "$TOTAL_PATH$ACCUMULATED_PATH/.git" | grep "^gitdir" | sed 's#^gitdir: *##')
      else
        set GIT_CONFIG ""
      end
      git_block_info "$TOTAL_PATH$ACCUMULATED_PATH/$GIT_CONFIG" | read -d '|' GIT_BG_COLOR GIT_BRANCH GIT_OPERATION GIT_ICONS

      set TOTAL_PATH "$TOTAL_PATH$ACCUMULATED_PATH"

      set ACCUMULATED_PATH (abbr_path "$ACCUMULATED_PATH")
      block "#3e3e3e" "#FFFFFF" " $ACCUMULATED_PATH "

      [ -n "$GIT_OPERATION" ] && block (darker_of $GIT_BG_COLOR) "#000000" " $GIT_OPERATION "
      block "$GIT_BG_COLOR" "#000000" " $GIT_BRANCH "
      [ -n "$GIT_ICONS" ] && block (darker_of $GIT_BG_COLOR) "#000000" " $GIT_ICONS "

      set ACCUMULATED_PATH ''

      if [ $CR_AFTER_GIT -eq 1 ]
        block "normal" "normal" " "
        set -g OLD_BG ""
        echo ""
      end
    end
  end

  [ "$ACCUMULATED_PATH" ] || set ACCUMULATED_PATH '/'
  set ACCUMULATED_PATH (abbr_path "$ACCUMULATED_PATH")

  block "#3e3e3e" "#FFFFFF" " $ACCUMULATED_PATH "
  block "normal" "normal" ""
  echo ""


  set -g OLD_BG ""
  echo -ne (fish_mode_prompt_2)
  block "normal" "normal" " "
end
