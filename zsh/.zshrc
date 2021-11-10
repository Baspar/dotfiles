# source ~/.bashrc

export ZSH="~/.oh-my-zsh"

ZSH_THEME="agnosterbaspar"
plugins=(git)

PATH="~/perl5/bin${PATH:+:${PATH}}"
PATH="/opt/homebrew/:/opt/homebrew/bin/:$PATH"
export PATH;

PERL5LIB="~/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="~/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"~/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=~/perl5"; export PERL_MM_OPT;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH/oh-my-zsh.sh
