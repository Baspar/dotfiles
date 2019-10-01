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
set undolevels=1000
set undoreload=10000
set hidden
" set foldmethod=syntax
set foldmethod=indent
set wildmenu
set spelllang=en
set spellfile=$HOME/.vim/spell/en.utf-8.add
set undodir=$HOME/.vim/undo//
set directory=$HOME/.vim/swap//
set shell=/bin/bash
set noswapfile

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
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
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

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
autocmd BufWritePre * StripWhitespace
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:instant_markdown_autostart = 0

let g:lion_squeeze_spaces = 1
let g:netrw_liststyle = 3
let g:netrw_banner = 0

highlight HighlightCurrentWord guibg=#463626 ctermbg=94
function! HighlightCurrentWordFn()
    if &filetype != "nerdtree" && &filetype != "fugitive" && &filetype != "fzf"
        try
            call matchdelete(4345)
        catch
        endtry
        let b:highlight_current_word_id = matchadd("HighlightCurrentWord", "\\<" . escape(expand("<cword>"), "\\/[]") ."\\>", -1, 4345)
        "match HighlightCurrentWord /\\<" . escape(expand("<cword>"), "\\/[]") . "\\>/"
    endif
endfunction

augroup highlight_current_word
    au!
    au CursorMoved * call HighlightCurrentWordFn()
augroup END
