filetype plugin on

"  General options
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
if has('nvim')
  set undodir=$HOME/.config/nvim/undo//
  set directory=$HOME/.config/nvim/swap//
else
  set undodir=$HOME/.vim/undo//
  set directory=$HOME/.vim/swap//
endif
set shell=/bin/bash
set noswapfile
set list
set listchars=tab:┋\ ,trail:■,eol:↩
set laststatus=2

" Color
set synmaxcol=300
augroup CustomColorChange
  function! s:custom_colors ()
    hi! Normal ctermbg=NONE guibg=NONE
    hi! Comment cterm=italic gui=italic
    hi! String cterm=italic gui=italic
    hi! lspInlayHintsParameter cterm=italic ctermfg=14 gui=italic guifg=#7e6956
    hi! lspInlayHintsType cterm=italic ctermfg=14 gui=italic guifg=#5e5e5e

    hi! LspDiagnosticsDefaultError guifg=red9 ctermfg=red
    hi! LspErrorHighlight cterm=undercurl gui=undercurl ctermfg=131 guifg=#af5f5f
    hi! LspErrorText ctermfg=131 guifg=#af5f5f

    hi! LspDiagnosticsDefaultWarning ctermfg=180 guifg=#dfaf87
    hi! LspWarningHighlight cterm=undercurl gui=undercurl ctermfg=180 guifg=#dfaf87
    hi! LspWarningText ctermfg=180 guifg=#dfaf87

    if &bg=="dark"
      hi! Furthest guibg=#202020 guifg=#ECE1D7
      hi! Further  guibg=#312F2E guifg=#C1A78E
      hi! Closer   guibg=#453e38 guifg=#B5A292
      hi! Closest  guibg=#AF875F guifg=#3E3E3E

      hi! WinSeparator guibg=NONE guifg=#453E38
      hi! Whitespace   gui=italic guifg=#4D453E

      hi! link LineNr Closer
    else
      hi! Furthest guibg=#FCF3CF guifg=#54433A
      hi! Further  guibg=#EBDAB4 guifg=#7C6F65
      hi! Closer   guibg=#D4C4A2 guifg=#7C6F65
      hi! Closest  guibg=#7C6F65 guifg=#FBF0C9

      hi! WinSeparator guibg=NONE guifg=#EBDAB4
      hi! Whitespace   gui=italic guifg=#D5C4A3

      hi! link LineNr Further
    endif

    hi! link Folded Closer

    hi! link NotifyBackground Further
    hi! link NotifyBackgroundSecondary Closer

    hi! link FzfBackground NotifyBackground
    hi! link FzfLuaNormal NotifyBackground
    hi! link FzfLuaBorder NotifyBackground
    hi! link FzfBackgroundSelected NotifyBackgroundSecondary
    hi! link FzfLuaPreviewNormal NotifyBackgroundSecondary
    hi! link FzfLuaCursorLineNr Folded
  endfunction

  au!
  au ColorScheme * call s:custom_colors()
  au VimEnter * call s:custom_colors()
  au FocusGained * call s:custom_colors()
  au User CustomColors call s:custom_colors()
augroup END

if exists('+termguicolors')
  let &t_8f = "\e[38;2;%lu;%lu;%lum"
  let &t_8b = "\e[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let &t_Cs = "\e[4:3m" " start undercurl
let &t_Ce = "\e[4:0m" " stop undercurl
let &t_SI = "\e[5 q" " start insert: blinking bar
let &t_SR = "\e[3 q" " start replace: blinking underscore
let &t_EI = "\e[1 q" " end insert/replace: blinking block
colorscheme melange

"  Indentation
set ts=2 sw=2 expandtab
au FileType sh setlocal ts=4 sw=4 expandtab
au FileType go setlocal ts=4 sw=4 sts=4 noexpandtab

au FileType git setlocal foldmethod=syntax

"  Netrw
autocmd FileType netrw vertical resize 30
let g:netrw_liststyle = 3
let g:netrw_banner = 0

"  STDIN
autocmd StdinReadPre * let s:std_in=1

"  Change default SQL mapping
let g:ftplugin_sql_omni_key = '<C-s>'

" vim: foldmethod=marker:foldlevel=1
