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


let g:GeomatMap = {
            \ 'wrong': '{name}/{name}.vim',
            \ 'config': '{name}/config.vim',
            \ 'plugins': '{name}/plugins.vim',
            \ 'mappings': '{name}/mappings.vim'
            \ }

" {
" }

function! s:Eq(a, b)
    return type(a:a) == type(a:b) && a:a == a:b
endfunction

function! s:SanitizePath(path)
    return substitute(a:path."$", "{[^}]*}", '\\([^/]*\\)', 'g')
endfunction

function! s:FindType(settings)
    let pairs = items(a:settings)
    let current_file = expand("%:p")
    for [type, path] in pairs
        let sanitized_path = s:SanitizePath(path)
        let match = matchlist(current_file, sanitized_path)
        if len(match) > 0
            let match_variables = {}
            let variable_names = []
            let root = matchlist(current_file, '^\(.*/\)'.sanitized_path)[1]
            call substitute(path, '{\zs[a-zA-Z]*\ze}', '\=add(variable_names, submatch(0))', 'g')
            let no_error = 1
            for id in range(len(variable_names))
                let variable_name = variable_names[id]
                let variable_value = match[id+1]
                if has_key(match_variables, variable_name) && match_variables[variable_name] != variable_value
                    let no_error = 0
                endif
                let match_variables[variable_name] = variable_value
            endfor

            if no_error == 1
                return { 'type': type, 'current_file': current_file, 'variables': match_variables, 'root': root }
            endif
        endif
    endfor
endfunction

function! GeomatNavigate(type, command)
    if !exists("g:GeomatMap")
        echohl WarningMsg
        echom "[Geomat] Please define your g:GeomatMap"
        echohl None
        return
    endif

    let current_file_info = s:FindType(g:GeomatMap)

    if s:Eq(current_file_info, 0)
        echohl WarningMsg
        echom "[Geomat] Cannot match current file with any type"
        echohl None
        return
    endif

    if !has_key(g:GeomatMap, a:type)
        echohl WarningMsg
        echom "[Geomat] Cannot find information for type '" . a:type . "'"
        echohl None
        return
    endif

    let path_with_variables = g:GeomatMap[a:type]
    let root = current_file_info['root']
    for [var_name, var_value] in items(current_file_info['variables'])
        let path_with_variables = substitute(path_with_variables, '{'.var_name.'}', var_value, 'g')
    endfor
    echom a:command
    if filereadable(root.path_with_variables)
        execute a:command root.path_with_variables
    else
        execute a:command root.path_with_variables
    endif
endfunction

command! -nargs=1 GNav call GeomatNavigate('<args>', 'edit')
command! -nargs=1 GNavS call GeomatNavigate('<args>', 'split')
command! -nargs=1 GNavV call GeomatNavigate('<args>', 'vsplit')
