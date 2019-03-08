function block # BG FG NEXT_BG ...TEXT
    set BG (echo $argv | cut -d\  -f1)
    set FG (echo $argv | cut -d\  -f2)
    set NEXT_BG (echo $argv | cut -d\  -f3)
    set TEXT (echo $argv | cut -d\  -f4-)

    set_color $FG -b $BG
    echo -n "$TEXT"
    set_color $BG -b $NEXT_BG
    echo -n ""
    set_color normal -b normal
end

function abbr_path # PATH
    if [ "$argv" = "$HOME" ]
        echo -n "~"
    else
        set ABBR_PATH (echo -n $argv | sed " s|^$HOME|~|; s|\([^/a-zA-Z0-9]*[a-zA-Z0-9]\)[^/]*/|\1/|g")
        echo -n "$ABBR_PATH"
        # (echo '$ABBR_PATH' | sed 's|^\(.*/\)\([^/]*\)\$|\1|')
        # (echo '$ABBR_PATH' | sed 's|^\(.*/\)\([^/]*\)\$|\2|')
    end
end

function git_prompt
    set GIT_ROOT $argv

    set GIT_STATUS (git status | grep "^[a-zA-Z0-9]")
    set GIT_BRANCH (cat $GIT_ROOT/.git/HEAD | \
        sed 's|^\([a-f0-9]\{9\}\)[a-f0-9]*$|\1|' | \
        cut -d' ' -f2- | \
        sed 's|refs/[^/]*/||g' | \
        tr -d '\n')

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

    # Print prefix
    set ABBR_GIT_ROOT (abbr_path $GIT_ROOT)
    block "#3e3e3e" "white" "$COLOR" " $ABBR_GIT_ROOT "

    # Build git string
    set GIT_STATUS (echo  " $GIT_BRANCH $ICONS " | sed 's/\s\+/ /g')
    block "$COLOR" "black" "#3e3e3e" "$GIT_STATUS"

    # Rest path
    set ABBR_GIT_PATH (abbr_path (pwd | sed "s|$GIT_ROOT||; s|^|/|; s|^//|/|"))
    block "#3e3e3e" "white" "normal" " $ABBR_GIT_PATH "
end

function fish_prompt
    set GIT_ROOT (git rev-parse --show-toplevel 2> /dev/null)

    if [ $GIT_ROOT ]
        git_prompt $GIT_ROOT
    else
        set ABBR_PWD (abbr_path $PWD)
        block "#3e3e3e" "white" "normal" " $ABBR_PWD "
    end

    echo -n " "
end
