source ~/.vim/plugins.vim
source ~/.vim/config.vim
source ~/.vim/mappings.vim

set exrc
if filereadable('.git/.vimrc')
    source '.git/.vimrc'
endif

if has('nvim')
    source ~/.vim/nvim_specific.vim
else
    source ~/.vim/vim_specific.vim
endif

source ~/.vim/geomat.vim
