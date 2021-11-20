#
# ~/.bashrc #

abbr() {
    NAME=""
    VALUE=""
    for I in $(seq $#)
    do
        ITEM=$(eval "echo \$$I")

        if [ "$(echo $ITEM | head -c 1)" != "-" ]
        then
            if [ "$NAME" == "" ]
            then
                NAME=$ITEM
            elif [ "$VALUE" == "" ]
            then
                VALUE=$ITEM
                break
            fi
        fi
    done
    alias $NAME="$VALUE"
}
source ~/.bash_aliases

export EDITOR='nvim'
export GOPATH="$HOME/.go"

ANDROID_HOME=~/.android/sdk/
TERM=xterm-256color
[ -e ~/.config/ripgrep/rc ] && export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/rc"

[ -e "~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0" ] && {
    export LD_PRELOAD=~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0
}

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
[ -e ~/.tokenrc ] && source ~/.tokenrc
export MOZ_USE_XINPUT2 DEFAULT=1
export QT_WAYLAND_FORCE_DPI=144

fs() {
	local -r fmt='#{session_id}:|#S|(#{session_attached} attached)'
	{ tmux display-message -p -F "$fmt" && tmux list-sessions -F "$fmt"; } \
		| awk '!seen[$1]++' \
		| column -t -s'|' \
		| fzf -q '$' --reverse --prompt 'switch session: ' -1 \
		| cut -d':' -f1 \
		| xargs tmux switch-client -t
}

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

PS1='\[\e[43m\e[30m \u@\h \e[100m \W \$\[\e[m\] '

export LEFT_SEPARATOR="▒"
export RIGHT_SEPARATOR="▒"
export LEFT_SUB_SEPARATOR="▒"
export RIGHT_SUB_SEPARATOR="▒"

source "$HOME/.cargo/env"
[ -e "$HOME/.env.vandebron" ] && source ~/.env.vandebron

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && alias  nvm="unalias npm yarn node nvm; . \"$NVM_DIR/nvm.sh\"; nvm $@"
[ -s "$NVM_DIR/nvm.sh" ] && alias  npm="unalias npm yarn node nvm; . \"$NVM_DIR/nvm.sh\"; npm $@"
[ -s "$NVM_DIR/nvm.sh" ] && alias yarn="unalias npm yarn node nvm; . \"$NVM_DIR/nvm.sh\"; yarn $@"
[ -s "$NVM_DIR/nvm.sh" ] && alias node="unalias npm yarn node nvm; . \"$NVM_DIR/nvm.sh\"; node $@"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/graalvm-ce-java8-21.0.0.2/Contents/Home/bin"

export PATH=$PATH:"~/.bin:$GOPATH/bin:~/.gem/ruby/2.4.0/bin:~/.gem/ruby/2.5.0/bin:$HOME/.cargo/bin"
export PATH=$PATH:"$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$HOME/.cargo/bin"
export PATH=$PATH:"$HOME/Library/Application Support/Coursier/bin"
export PATH=$PATH:"/usr/local/opt/llvm/bin"
export PATH=$PATH:"$GOPATH/bin"
export PATH=$PATH:"$JAVA_HOME/bin"
export PATH=$PATH:"$HOME/.rvm/bin"
export PATH="/usr/local/opt/curl/bin":$PATH
