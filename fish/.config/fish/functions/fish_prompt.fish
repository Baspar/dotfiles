function print_in_italic
    set BG (echo $argv | cut -d\  -f1)
    set FG (echo $argv | cut -d\  -f2)
    set TEXT (echo $argv | cut -d\  -f3-)

    set_color -b $BG
    set_color -i $FG
    echo -n $TEXT
    set_color -b normal
    set_color normal
end

function print_in_bold
    set BG (echo $argv | cut -d\  -f1)
    set FG (echo $argv | cut -d\  -f2)
    set TEXT (echo $argv | cut -d\  -f3-)

    set_color -b $BG
    set_color -o $FG
    echo -n $TEXT
    set_color -b normal
    set_color normal
end

function print_in
    set BG (echo $argv | cut -d\  -f1)
    set FG (echo $argv | cut -d\  -f2)
    set TEXT (echo $argv | cut -d\  -f3-)

    set_color -b $BG
    set_color $FG
    echo -n $TEXT
    set_color -b normal
    set_color normal
end

function print_abbr_path
    if [ "$argv" = "$HOME" ]
        print_in_bold "black" "white" "~"
    else
        set ABBR_PATH (echo -n $argv | sed " s|^$HOME|~|; s|\([^/a-zA-Z0-9]*[a-zA-Z0-9]\)[^/]*/|\1/|g")
        print_in      "black" "white" (echo "$ABBR_PATH" | sed "s|^\(.*/\)\([^/]*\)\$|\1|")
        print_in_bold "black" "white" (echo "$ABBR_PATH" | sed "s|^\(.*/\)\([^/]*\)\$|\2|")
    end
end

function fish_prompt
    set GIT_ROOT (git rev-parse --show-toplevel 2> /dev/null)

    if [ $GIT_ROOT ]
        # Print prefix
        print_abbr_path $GIT_ROOT

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
        set COLOR "green"
        set ICONS ""

        if [ $GIT_HAS_CHANGES_TO_COMMIT -eq 0 ]
            set ICONS "$ICONS+"
        end

        if [ $GIT_HAS_UNSTAGED -eq 0 ]
            set COLOR "yellow"
            set ICONS "$ICONS~"
        end

        if [ $GIT_HAS_UNTRACKED -eq 0 ]
            set COLOR "yellow"
            set ICONS "$ICONS?"
        end

        print_in "black" "$COLOR" " ░▒▓"
        print_in_bold "$COLOR" "black" " $GIT_BRANCH "
        if [ ! "$ICONS" = "" ]
            print_in_italic "$COLOR" "black" "$ICONS "
        end
        print_in "black" "$COLOR" "▓▒░ "

        print_abbr_path (pwd | sed "s|$GIT_ROOT||; s|^|/|; s|^//|/|")
    else
        print_abbr_path $PWD
    end

    print_in "normal" "black" "▓▒░ "

    echo -n " "
end
