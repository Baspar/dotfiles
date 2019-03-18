source ~/.bash_aliases
set -Ux EDITOR nvim
set -Ux LANG en_US.UTF-8
set -Ux LC_CTYPE en_US.UTF-8
set -Ux FZF_DEFAULT_COMMAND 'ag --nocolor --ignore node_modules -g ""'

set -Ux NVM_DIR "$HOME/.nvm"
set PATH "$HOME/.cargo/bin/" $PATH
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && source "/usr/local/opt/nvm/etc/"
