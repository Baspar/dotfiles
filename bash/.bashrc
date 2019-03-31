#
# ~/.bashrc #

# alias abbr='alias'
# source ~/.bash_aliases

export EDITOR='vim'
export GOPATH="$HOME/.go"

export GOPATH=$(go env GOPATH 2&> /dev/null)

ANDROID_HOME=~/.android/sdk/
PATH="$PATH:~/.bin:$GOPATH/bin:~/.gem/ruby/2.4.0/bin:~/.gem/ruby/2.5.0/bin:$HOME/.cargo/bin"
TERM=xterm
PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$HOME/.cargo/bin

export LD_PRELOAD=~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
[ -e ~/.tokenrc ] && source ~/.tokenrc
export MOZ_USE_XINPUT2 DEFAULT=1

fs() {
	local -r fmt='#{session_id}:|#S|(#{session_attached} attached)'
	{ tmux display-message -p -F "$fmt" && tmux list-sessions -F "$fmt"; } \
		| awk '!seen[$1]++' \
		| column -t -s'|' \
		| fzf -q '$' --reverse --prompt 'switch session: ' -1 \
		| cut -d':' -f1 \
		| xargs tmux switch-client -t
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
