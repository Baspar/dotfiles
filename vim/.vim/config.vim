set backspace=indent,eol,start
set nocompatible
set encoding=utf8
syntax on
filetype plugin on
set number
set relativenumber
set mouse=a
let mapleader=","
let maplocalleader=" "
set nowrap
set hlsearch
set incsearch
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000
set hidden
set foldmethod=syntax
" set foldmethod=indent
set wildmenu
set spelllang=en
set spellfile=$HOME/.vim/spell/en.utf-8.add
set directory=$HOME/.vim/swap
set shell=/bin/bash

" set termguicolors
set t_Co=256

" Function
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction


" Color
colorscheme alduin
hi Normal guibg=NONE ctermbg=NONE

" Indentation
set tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript,jsx set tabstop=2 shiftwidth=2 expandtab
autocmd FileType css set tabstop=2 shiftwidth=2 expandtab

autocmd StdinReadPre * let s:std_in=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows = 1
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js"
let g:clojure_align_multiline_strings = 1
let g:sexp_insert_after_wrap = 'false'
let g:airline_theme='minimalist'
let g:airline_powerline_fonts = 1
autocmd BufWritePre * StripWhitespace
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:instant_markdown_autostart = 0

let g:GeomatMap = {
            \ 'wrong': '{name}/{name}.vim',
            \ 'config': '{name}/config.vim',
            \ 'geomat': '{name}/geomat.vim',
            \ 'plugins': '{name}/plugins.vim',
            \ 'mappings': '{name}/mappings.vim'
            \ }
let g:GeomatRoot = 'vim/.vim'
