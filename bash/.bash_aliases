ls --color 1>/dev/null 2>/dev/null && alias ls='ls --color' || alias ls='ls -G'
abbr l 'ls -lh'
abbr ll 'ls -lah'

abbr gm 'git merge'
abbr gd 'git diff'
abbr gp 'git push'
abbr gpt 'git push --tags'
abbr gP 'git pull -p -r --all'
abbr ga 'git add'
abbr gt 'git tag'
abbr gs 'git status -s'
abbr gss 'git status'
abbr gS 'git stash'
abbr gc 'git commit'
abbr gC 'git checkout'
abbr gCo 'git checkout --our'
abbr gCt 'git checkout --their'
abbr gpsu 'git push --set-upstream origin HEAD'
abbr gpf 'git push --force-with-lease'
abbr gr "git rebase"
abbr gR "git reset"
abbr gb "git branch"
abbr gn "git notes"
abbr gba "git branch --all"
abbr gclone "git clone --recursive gh:"

abbr y "yarn"
abbr yt "yarn test"
abbr yl "yarn lint"

abbr h 'head'
abbr t 'tmux'
abbr ta 'tmux a'
abbr tat 'tmux a -t'

# abbr cp 'acp -g'
# abbr mv 'amv -g'

abbr m 'make'
abbr mc 'make clean'

abbr free 'free -h'
abbr f 'free'

command -v nvim > /dev/null && abbr vim 'nvim'
command -v nvim > /dev/null && abbr vi  'nvim' || abbr vi 'vim'
command -v nvim > /dev/null && abbr v   'nvim' || abbr vi 'vim'

abbr o 'xdg-open'

abbr df 'df -h'

command -v pbcopy > /dev/null  || abbr pbcopy 'xsel --clipboard --input'
command -v pbpaste > /dev/null || abbr pbpaste 'xsel --clipboard --output'

abbr se 'sudoedit'
abbr nvm 'bass source /usr/local/opt/nvm/nvm.sh --no-use ";" nvm'
