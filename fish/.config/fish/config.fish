source ~/.bash_aliases
[ -e "$HOME/.env.vandebron" ]; and source ~/.env.vandebron
set -Ux EDITOR nvim
set -Ux LANG en_US.UTF-8
set -Ux LC_CTYPE en_US.UTF-8
set -Ux FZF_DEFAULT_COMMAND 'rg -l .'
set -Ux VIRTUAL_ENV_DISABLE_PROMPT 'true'
set -Ux fish_greeting
set -x GPG_TTY (tty)

set -Ux QT_WAYLAND_FORCE_DPI 144
set -Ux fish_term24bit 1

set -Ux TZ "Europe/Amsterdam"
set -g SHELL (which fish)

set -Ux GOPATH ~/.go

# set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/graalvm-ce-java8-21.0.0.2/Contents/Home/bin"

# set -Ux LEFT_SEPARATOR ""
# set -Ux RIGHT_SEPARATOR ""
# set -Ux LEFT_SUB_SEPARATOR ""
# set -Ux RIGHT_SUB_SEPARATOR ""

set -Ux LEFT_SEPARATOR "▒"
set -Ux RIGHT_SEPARATOR "▒"
set -Ux LEFT_SUB_SEPARATOR "▒"
set -Ux RIGHT_SUB_SEPARATOR "▒"

alias java11 "set -x JAVA_HOME /Library/Java/JavaVirtualMachines/jdk-11.0.2.jdk/Contents/Home"
alias java8 "set -x JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_212.jdk/Contents/Home"
alias graal8 "set -x JAVA_HOME /Library/Java/JavaVirtualMachines/graalvm-ce-java8-21.0.0.2/Contents/Home"
# [ -e "/Library/Java/JavaVirtualMachines/graalvm-ce-java8-21.0.0.2/Contents/Home" ]; and graal8

set -Ux NVM_DIR "$HOME/.nvm"

set PATH \
    "/opt/homebrew/bin" \
    "/Users/bastien/Library/Application Support/Coursier/bin" \
    "/Applications/KeePassXC.app/Contents/MacOS" \
    "/usr/local/opt/curl/bin" \
    "$HOME/.toolbox/bin" \
    "$HOME/.bin" \
    "/usr/local/bin" \
    "$HOME/.rvm/bin" \
    "$HOME/.cargo/bin/" \
    "$JAVA_HOME/bin" \
    "$GOPATH/bin" \
    "$HOME/.yarn/bin" \
    $PATH \
    "/usr/local/opt/llvm/bin"

alias npm "functions --erase npm yarn node; load_nvm; npm $argv"
alias yarn "functions --erase npm yarn node; load_nvm; yarn $argv"
alias node "functions --erase npm yarn node; load_nvm; node $argv"

[ -e ~/.config/ripgrep/rc ] && set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/rc"

source ~/.config/fish/fish_prompt.fish

status is-interactive; or return

# Import colorscheme
if test -e ~/.dircolors
    switch (uname)
        case Darwin
            eval (gdircolors -c ~/.dircolors/dircolors)

        case Linux
            eval (dircolors -c ~/.dircolors/dircolors)
    end
end

set fish_color_search_match --background='333'

function update_tmux_current_pwd --on-variable PWD
    [ -n "$TMUX" ] && tmux setenv TMUXPWD_(tmux display -p "#D" | tr -d %) "$PWD"
end
update_tmux_current_pwd

bind -M insert \ck 'up-or-search'
bind -M insert \cj 'down-or-search'

function errcho
    echo $argv 1>&2;;
end

set -eg THEME
function check_theme --on-event fish_prompt
    set theme (bash ~/.bin/osc11.bash)
    if [ "$THEME" != "$theme" ]
        set -Ux THEME $theme
        if command -v tmux &> /dev/null
            tmux setenv -g THEME $theme
            tmux source ~/.tmux.conf
        end
        set_colorscheme
    end
end
