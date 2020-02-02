# source ~/.bashrc

export ZSH="/home/baspar/.oh-my-zsh"

ZSH_THEME="agnosterbaspar"
plugins=(git)

PATH="/home/baspar/perl5/bin${PATH:+:${PATH}}"; export PATH;

PERL5LIB="/home/baspar/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/baspar/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/baspar/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/baspar/perl5"; export PERL_MM_OPT;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH/oh-my-zsh.sh
