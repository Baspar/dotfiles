function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

call plug#begin('~/.vim/plugged')

  " {{{ AutoPairs
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'
  " }}}

  " {{{ TCommentVim
  Plug 'tomtom/tcomment_vim'
  " }}}

  " {{{ VimLion
  Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1
  " }}}

  " {{{ VimAbolish
  Plug 'tpope/vim-abolish'
  " }}}

  " {{{ Nerdtree
  Plug 'scrooloose/nerdtree'
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1
  let g:NERDTreeQuitOnOpen = 1
  " }}}

  " {{{ VimCartographe
  Plug 'gh:baspar/vim-cartographe'
  " }}}

  " {{{ EasyMotion
  Plug 'easymotion/vim-easymotion'
  " }}}

  " {{{ LSP
  Plug 'neovim/nvim-lspconfig', Cond(has('nvim'))
  Plug 'hrsh7th/nvim-compe', Cond(has('nvim'))
  Plug 'glepnir/lspsaga.nvim', Cond(has('nvim'))
  " }}}

  "{{{ Nvim-TreeSitter
  Plug 'nvim-treesitter/nvim-treesitter', Cond(has('nvim'), {'do': ':TSUpdate'})
  "}}}

  " {{{ Polyglot
  Plug 'sheerun/vim-polyglot'
  " }}}

  " {{{ Fish
  Plug 'dag/vim-fish', {'for': ['fish']}
  " }}}

  " {{{ Clojure
  Plug 'guns/vim-clojure-static', {'for': ['clojure']}
  Plug 'guns/vim-sexp', {'for': ['clojure']}
  Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': ['clojure']}
  let g:clojure_align_multiline_strings = 1
  let g:sexp_insert_after_wrap = 'false'
  " }}}

  " {{{ Undotree
  Plug 'mbbill/undotree'
  " }}}

  " {{{ FZF
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  let g:fzf_colors = {
      \ 'prompt': ['fg', 'Type'],
      \ 'bg':      ['bg', 'Pmenu'],
      \ 'hl': ['fg', 'Type'],
      \ 'hl+': ['fg', 'Number'],
      \ }
  let g:fzf_preview_window = ''
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.5 } }
  " }}}

  " {{{ VimFugitive
  Plug 'tpope/vim-fugitive'
  " }}}

  " {{{ VimDispatch & Async
  Plug 'tpope/vim-dispatch'
  Plug 'prabirshrestha/async.vim'
  " }}}

  " {{{ VimSandwich
  Plug 'machakann/vim-sandwich'
  " }}}

  " {{{ Lightline.Vim
  Plug 'itchyny/lightline.vim'
  " }}}

  " {{{ Colorschemes
  Plug 'fcpg/vim-fahrenheit'
  Plug 'AlessandroYorba/alduin'
  Plug 'fcpg/vim-orbital'
  Plug 'fcpg/vim-farout'
  Plug 'habamax/vim-gruvbit'
  " }}}
call plug#end()

" vim: foldmethod=marker:foldlevel=0
