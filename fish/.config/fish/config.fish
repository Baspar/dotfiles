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

set -g SHELL "fish"

set -Ux GOPATH ~/.go

set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/graalvm-ce-java8-21.0.0.2/Contents/Home/bin"

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
[ -e "/Library/Java/JavaVirtualMachines/graalvm-ce-java8-21.0.0.2/Contents/Home" ]; and graal8

set -Ux NVM_DIR "$HOME/.nvm"

set PATH \
    "/opt/homebrew/bin" \
    "/Users/bastien/Library/Application Support/Coursier/bin" \
    "/usr/local/opt/curl/bin" \
    "$HOME/.toolbox/bin" \
    "$HOME/.bin" \
    "$HOME/.rvm/bin" \
    "$HOME/.cargo/bin/" \
    "$JAVA_HOME/bin" \
    "$GOPATH/bin" \
    "$HOME/.yarn/bin" \
    $PATH \
    "/usr/local/opt/llvm/bin"

[ -e ~/.config/ripgrep/rc ] && set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/rc"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/baspar/.gcloud/path.fish.inc' ]
    . '/Users/baspar/.gcloud/path.fish.inc'
end

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

source ~/.config/fish/fish_prompt.fish

# [ -d ~/.config/fish/completions ] && source ~/.config/fish/completions/*.fish
alias npm "functions --erase npm yarn node; load_nvm; npm $argv"
alias yarn "functions --erase npm yarn node; load_nvm; yarn $argv"
alias node "functions --erase npm yarn node; load_nvm; node $argv"
