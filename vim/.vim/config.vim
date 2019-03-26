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

let g:slime_target = "vimterminal"
let g:slime_no_mappings = 1
let g:ale_linters = {'javascript': ['eslint', 'standard'], 'clojure': ['joker']}
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

" '/src/test/components/SearchTable/index.spec.js'

let g:xxx = {
            \ 'config': '{name}/config.vim',
            \ 'plugins': '{name}/plugins.vim',
            \ 'mappings': '{name}/mappings.vim'
            \ }

function! FindFileType()
    let pairs = items(g:xxx)
    let current_file = expand("%:f")
    for [type, path] in pairs
        let sanitized_path = substitute(path, "{[^}]*}", '\\([^/]*\\)', "g")
        let match = matchlist(current_file, sanitized_path)
        if len(match) > 0
            echo "You're in a file of type \"" . type . "\""
            let match_variables = {}
            let variable_names = []
            call substitute(path, '{\zs[a-zA-Z]*\ze}', '\=add(variable_names, submatch(0))', 'g')
            for id in range(len(variable_names))
                let variable_name = variable_names[id]
                let variable_value = match[id+1]
                let match_variables[variable_name] = variable_value
            endfor

            echo match_variables
            return
        endif
    endfor
    echo "Nope"
endfunction

nmap <leader><leader>g :call FindFileType()<CR>
