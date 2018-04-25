#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -h --color=auto'
alias l='ls -l'
alias ll='ls -la'
alias gp='git push'
alias gP='git pull'
alias ga='git add'
alias gs='git status'
alias gS='git stash'
alias gc='git commit'
alias gC='git checkout'
alias gpsu='git push --set-upstream origin HEAD'
alias gpf='git push --force'
function gclone () {
}
alias xx='termite& disown'

# alias cp='acp -g'
# alias mv='amv -g'

alias m='make'
alias mc='make clean'

alias free='free -h'
alias f='free'

alias vimrc='vim ~/.vimrc'
# alias vim='nvim'
alias vi='vim'
alias v='vim'

alias o='xdg-open'

alias df='df -h'

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias rlf='rlwrap lein figwheel'
alias rlfa='rlwrap lein figwheel android'

alias aws_scb='aws --profile scb'

alias repl='cd ~/.repl; lein repl; cd -'

alias weather='curl -s wttr.in | head -n -2'

alias scd='cd'
alias sl='ls'

alias py='python3'

export EDITOR='vim'
export GOPATH="$HOME/.go"

alias j='jobs'
alias t='tree'

alias tmux='TERM=screen-256color-bce tmux'

export GOPATH=$(go env GOPATH)

function grepin () {
    echo $#
    [ $# -ne 2 ] && {
        echo "Wrong number of params (2)"
        return 1
    }

    path_file=$1
    pattern=$2

    echo $PATH
    files=$(find $path_file -type f)

    for file in $files
    do
        cat $file | grep "$pattern" && echo "======> Found in $file"
    done
}

ANDROID_HOME=/home/baspar/.android/sdk/
PATH="$PATH:/home/baspar/.bin:$GOPATH/bin:/home/baspar/.gem/ruby/2.4.0/bin:/home/baspar/.gem/ruby/2.5.0/bin"
TERM=xterm
PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

export GOBOT_DIALOGFLOW_TOKEN="cc1ab36d5b064b3e92dbe2547b397e64"
export GOBOT_TELEGRAM_TOKEN="518276016:AAHbtj6ls3eiz2Hrj6pDDg3AtSGpzO2twyU"

export LD_PRELOAD=~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
