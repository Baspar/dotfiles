source ~/.vim/plugins.vim
source ~/.vim/config.vim
source ~/.vim/mappings.vim
source ~/.vim/statusline.vim

set exrc
if filereadable(getcwd().'/.git/vimrc')
    execute "source" getcwd().'/.git/vimrc'
endif

if has('nvim')
    source ~/.vim/nvim_specific.vim
else
    source ~/.vim/vim_specific.vim
endif
