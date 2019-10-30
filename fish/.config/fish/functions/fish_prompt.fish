#!/usr/bin/env fish

function fish_prompt
  # Function fish_prompt
  #
  # @returns A fancy prompt

  set -g OLD_BG ""

  function block
    # Function block
    #
    # @param BG: Background color of the block
    # @param FG: Foreground color of the block
    # @param ...TEXT: Text to display in the block
    #
    # @returns: A block with style and text

    echo $argv | read -d ' ' BG FG TEXT

    if [ "$OLD_BG" != "" ] && [ -z "$FISH_NO_POWERLINE" ]
      set_color $OLD_BG -b $BG
      echo -n ""
    end

    set_color $FG -b $BG
    echo -n "$TEXT"
    set -g OLD_BG $BG
    set_color normal -b normal
  end

  function abbr_path
    # Function abbr_path
    #
    # @param PATH_PART a part of the PATH
    #
    # @returns: An abbreviated version of the PATH_PART (one letter, but keep prefix special characters)
    #           with $HOME replaced by ~

    echo -n $argv | sed "s#^$HOME#~#; s#\([^/a-zA-Z0-9]*[a-zA-Z0-9]\)[^/]*/#\1/#g"
  end

  function darker_of
    # Function darker_of
    #
    # @param COLOR a color part of the list
    #
    # @returns: A darker shade of this color

    if [ "$argv" = "#AF875F" ]
      echo -n "#926E49"
    else if [ "$argv" = "#4B8252" ]
      echo -n "#38623E"
    else
      echo -n ""
    end
  end


  function git_block_info
    # Function git_block_info
    #
    # @param GIT_ROOT: Absolute path of the current folder
    # @param GIT_CONFIG: Absolute path of the .git folder
    #                    If unspecified, set to $GET_ROOT/.git
    #
    # @returns: The color and status of the git information at given GIT_ROOT

    echo $argv | read -d ' ' -l GIT_ROOT GIT_CONFIG

    if [ "$GIT_CONFIG" = "" ]
      set GIT_CONFIG "$GIT_ROOT/.git"
    end

    set GIT_STATUS (git -C $GIT_ROOT status | grep "^[a-zA-Z0-9]")

    set GIT_BRANCH (cat $GIT_CONFIG/HEAD | \
        sed 's|^\([a-f0-9]\{9\}\)[a-f0-9]*$|\1|' | \
        cut -d' ' -f2- | \
        sed 's|refs/[^/]*/||g' | \
        tr -d '\n')

    set GIT_AHEAD (git -C $GIT_ROOT status | grep "Your branch is ahead of '[^']*' by [0-9]* commit.")
    if [ "$GIT_AHEAD" ]
      set GIT_AHEAD_OF (echo $GIT_AHEAD | sed "s#Your branch is ahead of '[^']*' by \([0-9]*\) commit.*#\1#")
    end

    # Untracked files
    echo $GIT_STATUS | grep "Untracked files:" > /dev/null
    set GIT_HAS_UNTRACKED $status

    # Untracked files
    echo $GIT_STATUS | grep "Changes not staged for commit:" > /dev/null
    set GIT_HAS_UNSTAGED $status

    # Change to be commited
    echo $GIT_STATUS | grep "Changes to be committed:" > /dev/null
    set GIT_HAS_CHANGES_TO_COMMIT $status

    # Default color
    set COLOR "#4B8252"
    set ICONS ""

    # Colors and icons
    if [ $GIT_HAS_CHANGES_TO_COMMIT -eq 0 ]
      set ICONS "$ICONS+"
    end
    if [ $GIT_HAS_UNSTAGED -eq 0 ]
      set COLOR "#AF875F"
      set ICONS "$ICONS~"
    end
    if [ $GIT_HAS_UNTRACKED -eq 0 ]
      set COLOR "#AF875F"
      set ICONS "$ICONS?"
    end

    # Build git string
    echo -n "$COLOR|$GIT_AHEAD_OF|$GIT_BRANCH $ICONS" | sed 's# $##'
  end


  set_color white -b '#3e3e3e'

  set TOTAL_PATH ''
  set ACCUMULATED_PATH ''

  for PWD_PART in (echo $PWD | sed 's#^/##; s#/$##' |  tr '/' '\n')
    set ACCUMULATED_PATH "$ACCUMULATED_PATH/$PWD_PART"
    if [ -e "$TOTAL_PATH$ACCUMULATED_PATH/.git" ]
      if [ -f "$TOTAL_PATH$ACCUMULATED_PATH/.git" ]
        set GIT_CONFIG (cat "$TOTAL_PATH$ACCUMULATED_PATH/.git" | grep "^gitdir" | sed "s#^gitdir:\s*##")
        git_block_info "$TOTAL_PATH$ACCUMULATED_PATH" "$TOTAL_PATH$ACCUMULATED_PATH/$GIT_CONFIG" \
          | read -d '|' GIT_BG_COLOR GIT_AHEAD_OF GIT_STATUS
      else if [ -e "$TOTAL_PATH$ACCUMULATED_PATH/.git/config" ]
        git_block_info "$TOTAL_PATH$ACCUMULATED_PATH" \
          | read -d '|' GIT_BG_COLOR GIT_AHEAD_OF GIT_STATUS
      end

      set TOTAL_PATH "$TOTAL_PATH$ACCUMULATED_PATH"

      set ACCUMULATED_PATH (abbr_path "$ACCUMULATED_PATH")
      block "#3e3e3e" "white" " $ACCUMULATED_PATH "

      if [ "$GIT_AHEAD_OF" != "" ]
        set GIT_DARKER_BG (darker_of $GIT_BG_COLOR)
        block "$GIT_DARKER_BG" "black" " $GIT_AHEAD_OF "
      end

      block "$GIT_BG_COLOR" "black" " $GIT_STATUS "
      set ACCUMULATED_PATH ''
    end
  end

  [ "$ACCUMULATED_PATH" ] || set ACCUMULATED_PATH '/'
  set ACCUMULATED_PATH (abbr_path "$ACCUMULATED_PATH")

  block "#3e3e3e" "white" " $ACCUMULATED_PATH "

  block "normal" "normal" " "
end
