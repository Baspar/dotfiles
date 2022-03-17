filetype plugin on

" {{{ General options
set nowrap
set completeopt=menu,menuone,noselect
set noemoji
set backspace=indent,eol,start
set nocompatible
set encoding=utf8
set number
set relativenumber
set mouse=a
let mapleader=","
let maplocalleader=" "
set hlsearch
set incsearch
set undofile
set undolevels=1000
set undoreload=10000
set hidden
set foldmethod=indent
set wildmenu
set spelllang=en
set spellfile=$HOME/.vim/spell/en.utf-8.add
set undodir=$HOME/.vim/undo//
set directory=$HOME/.vim/swap//
set shell=/bin/bash
set noswapfile
set list
set listchars=tab:┋\ ,trail:✗,eol:↴
set laststatus=3
" }}}

" {{{ Color
set synmaxcol=300
colorscheme melange
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
augroup CustomColorChange
  function! s:custom_colors ()
    hi! Normal ctermbg=NONE guibg=NONE
    hi! SignColumn ctermbg=233 guibg=#121212
    hi! Comment cterm=italic gui=italic
    hi! String cterm=italic gui=italic
    hi! Sneak ctermfg=237 ctermbg=3 guifg=#3A3A3A guibg=#AF875F
    hi! LspDiagnosticsDefaultError guifg=red ctermfg=red
    hi! LspErrorHighlight cterm=undercurl gui=undercurl ctermfg=131 guifg=#af5f5f
    hi! LspDiagnosticsDefaultWarning ctermfg=180 guifg=#dfaf87
    hi! LspWarningHighlight cterm=undercurl gui=undercurl ctermfg=180 guifg=#dfaf87
  endfunction

  au!
  au ColorScheme * call s:custom_colors()
  au VimEnter * call s:custom_colors()
augroup END
" }}}

" {{{ Indentation
set tabstop=2 shiftwidth=2 expandtab
autocmd FileType sh set tabstop=4 shiftwidth=4 expandtab
" }}}

" {{{ Netrw
autocmd FileType netrw vertical resize 30
let g:netrw_liststyle = 3
let g:netrw_banner = 0
" }}}

" {{{ STDIN
autocmd StdinReadPre * let s:std_in=1
" }}}

" {{{ Trailing spaces
hi! TrailingSpaces ctermbg=131 guibg=#af5f5f
match TrailingSpaces / \+$/
" }}}

" {{{ Change default SQL mapping
let g:ftplugin_sql_omni_key = '<C-s>'
" }}}

" {{{
let g:coq_settings = {
  \   'auto_start': 'shut-up',
  \   'display': {
  \     'pum': {
  \       'fast_close': v:false
  \     },
  \     'preview': {
  \       'positions': { "north": 1, "west": 2, "south": 3, "east": 4 }
  \     }
  \   }
  \ }
" }}}

" vim: foldmethod=marker:foldlevel=0
