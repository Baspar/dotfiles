function! If(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

call plug#begin('~/.vim/plugged')
  " {{{ Repeat
  Plug 'tpope/vim-repeat'
  " }}}

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

  " {{{ LSP
  if has('nvim')
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'neovim/nvim-lspconfig'
    Plug 'echasnovski/mini.notify'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvimtools/none-ls.nvim'
    Plug 'liuchengxu/vista.vim'
  else
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-buffer.vim'
    Plug 'prabirshrestha/asyncomplete-file.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
  endif
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'rafamadriz/friendly-snippets'
  " }}}

  " {{{ Undotree
  Plug 'mbbill/undotree'
  " }}}

  " {{{ vim-TreeSitter
  Plug 'nvim-treesitter/nvim-treesitter', If(has('nvim'), {'do': ':TSUpdate', 'branch': 'main'})
  " }}}

  " {{{ Polyglot
  Plug 'sheerun/vim-polyglot'
  Plug 'jasdel/vim-smithy'
  Plug 'dag/vim-fish'
  " }}}

  " {{{ Clojure
  Plug 'guns/vim-clojure-static', {'for': ['clojure']}
  Plug 'guns/vim-sexp', {'for': ['clojure']}
  Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': ['clojure']}
  let g:clojure_align_multiline_strings = 1
  let g:sexp_insert_after_wrap = 'false'
  " }}}

  " {{{ FZF
  if has('nvim')
    Plug 'ibhagwan/fzf-lua'
  else
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    let g:fzf_colors = {
        \ 'prompt': ['fg', 'Type'],
        \ 'bg':     ['bg', 'FZFBackground', 'Pmenu'],
        \ 'bg+':    ['bg', 'FZFBackgroundSelected'],
        \ }
    let g:fzf_preview_window = ''
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
  endif
  " }}}

  " {{{ VimFugitive
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  " }}}

  " {{{ VimSandwich
  Plug 'machakann/vim-sandwich'
  " }}}

  " {{{ IndentLine
  Plug 'lukas-reineke/indent-blankline.nvim', If(has('nvim'))
  " }}}

  " {{{ Vim Sneak
  " Plug 'justinmk/vim-sneak'
  Plug 'https://codeberg.org/andyg/leap.nvim'
  " }}}

  Plug 'justinmk/vim-ipmotion'
  let g:ip_skipfold = 1

  " {{{ Colorschemes
  Plug 'rktjmp/lush.nvim'

  Plug 'ab-dx/ares.nvim'
  Plug 'savq/melange-nvim'
  Plug 'ramojus/mellifluous.nvim'
  Plug 'rebelot/kanagawa.nvim'
  Plug 'sainnhe/everforest'
  Plug 'zenbones-theme/zenbones.nvim'
  Plug 'rose-pine/neovim'


  Plug 'fcpg/vim-fahrenheit'
  Plug 'AlessandroYorba/alduin'
  Plug 'fcpg/vim-orbital'
  Plug 'fcpg/vim-farout'
  Plug 'habamax/vim-gruvbit'
  " }}}
call plug#end()

" vim: foldmethod=marker:foldlevel=0
