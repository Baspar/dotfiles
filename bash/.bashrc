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
alias gc='git commit'
alias gC='git checkout'
alias xx='termite& disown'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

alias df='df -h'

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias rlf='rlwrap lein figwheel'

alias aws_scb='aws --profile scb'

alias repl='cd ~/.repl; lein repl; cd -'

alias weather='curl -s wttr.in | head -n -2'

export EDITOR='nvim'

PATH="$PATH:/home/baspar/.bin"

