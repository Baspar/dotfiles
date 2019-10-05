source ~/.bash_aliases
set -Ux EDITOR nvim
set -Ux LANG en_US.UTF-8
set -Ux LC_CTYPE en_US.UTF-8
set -Ux FZF_DEFAULT_COMMAND 'ag --nocolor --ignore node_modules -g ""'

set -Ux NVM_DIR "$HOME/.nvm"
set PATH "$HOME/.bin" "$HOME/.rvm/bin" "$HOME/.yarn/bin" "$HOME/.cargo/bin/" $PATH
[ -e ~/.config/ripgrep/rc ] && set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/rc"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && source "/usr/local/opt/nvm/etc/"
# rvm default

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/baspar/.gcloud/path.fish.inc' ]
    . '/Users/baspar/.gcloud/path.fish.inc'
end

abbr java11 "set -x JAVA_HOME /Library/Java/JavaVirtualMachines/jdk-11.0.2.jdk/Contents/Home"
abbr java8 "set -x JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
