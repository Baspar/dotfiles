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

    let colors = {
      \ 'Red':        {'bg': '#AF5F5E', 'fg': '#FFFFFF'},
      \ 'Yellow':     {'bg': '#AF875F', 'fg': '#FFFFFF'},
      \ 'Green':      {'bg': '#A1B56C', 'fg': '#FFFFFF'},
      \ }

    let colors = extend(colors, &bg=="dark" ? {
      \ 'RedSecondary':    {'bg': '#703D3D', 'fg': '#FFFFFF'},
      \ 'YellowSecondary': {'bg': '#926E49', 'fg': '#FFFFFF'},
      \ 'GreenSecondary':  {'bg': '#38623E', 'fg': '#FFFFFF'},
      \ 'Background':      {'bg': '#202020', 'fg': '#ECE1D7'},
      \ 'Furthest':        {'bg': '#292827', 'fg': '#ECE1D7'},
      \ 'Further':         {'bg': '#3B3733', 'fg': '#C1A78E'},
      \ 'Closer':          {'bg': '#53483D', 'fg': '#B5A292'},
      \ 'Closest':         {'bg': '#AF875F', 'fg': '#3E3E3E'},
      \ } : {
      \ 'RedSecondary':    {'bg': '#A26865', 'fg': '#FFFFFF'},
      \ 'YellowSecondary': {'bg': '#A88B6D', 'fg': '#FFFFFF'},
      \ 'GreenSecondary':  {'bg': '#90A261', 'fg': '#FFFFFF'},
      \ 'Background':      {'bg': '#FCF3CF', 'fg': '#54433A'},
      \ 'Furthest':        {'bg': '#F4E7C2', 'fg': '#54433A'},
      \ 'Further':         {'bg': '#EBDAB4', 'fg': '#7C6F65'},
      \ 'Closer':          {'bg': '#D4C4A2', 'fg': '#7C6F65'},
      \ 'Closest':         {'bg': '#7C6F65', 'fg': '#FBF0C9'},
      \ })

    for [name, c] in items(colors)
      for [reverse_suffix, reverse_c] in items({
            \ ''        : [c.bg, c.fg],
            \ '_reverse': [c.fg, c.bg],
            \ })
        let [bg, fg] = reverse_c
        for [gui_suffix, gui] in items({
            \ ''            : '',
            \ '_bold'       : ' gui=bold',
            \ '_italic'     : ' gui=italic',
            \ '_bold_italic': ' gui=bold,italic',
            \ })
          exe 'hi! ' . name . ''    . reverse_suffix . gui_suffix . ' guibg=' . bg . ' guifg=' . fg . gui
          exe 'hi! ' . name . '_bg' . reverse_suffix . gui_suffix . ' guibg=' . bg . gui
          exe 'hi! ' . name . '_fg' . reverse_suffix . gui_suffix . ' guifg=' . fg . gui
        endfor
      endfor
    endfor

    if &bg=="dark"
      hi! Whitespace gui=italic guifg=#4D453E
    else
      hi! Whitespace gui=italic guifg=#D5C4A3
    endif

    hi! link CurSearch YellowSecondary_bold
    hi! link LeapLabel RedSecondary
    hi! link Search RedSecondary
    hi! link LineNr Further
    hi! link CursorLineNr Closer
    hi! link CursorLine Furthest_bg
    hi! link WinSeparator Further_fg_reverse

    hi! link TabLine Further
    hi! link TabLineFill Furthest
    hi! link TabLineSel Closer_bold

    hi! link Folded Closer
    hi! link NotifyBackground Further
    hi! link NotifyBackgroundSecondary Closer
    hi! link FzfBackground NotifyBackground
    hi! link FzfLuaNormal NotifyBackground
    hi! link FzfLuaBorder NotifyBackground
    hi! link FzfBackgroundSelected NotifyBackgroundSecondary
    hi! link FzfLuaPreviewNormal NotifyBackgroundSecondary
    hi! link FzfLuaCursorLineNr Folded

    hi! link Sneak Closest
    hi! link HighlightCurrentWord Further_bg
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
