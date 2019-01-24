#
# ~/.bashrc
#

alias abbr=alias

source ~/.bash_aliases

export EDITOR='vim'
export GOPATH="$HOME/.go"

export GOPATH=$(go env GOPATH)

ANDROID_HOME=~/.android/sdk/
PATH="$PATH:~/.bin:$GOPATH/bin:~/.gem/ruby/2.4.0/bin:~/.gem/ruby/2.5.0/bin:$HOME/.cargo/bin"
TERM=xterm
PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

export LD_PRELOAD=~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
source ~/.tokenrc
export MOZ_USE_XINPUT2 DEFAULT=1
