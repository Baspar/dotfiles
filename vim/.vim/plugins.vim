call plug#begin('~/.vim/plugged')
  " {{{ Vimspector
  " Plug 'puremourning/vimspector'
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

  " {{{ VimCartographe
  Plug 'gh:baspar/vim-cartographe'
  " }}}

  " {{{ EasyMotion
  Plug 'easymotion/vim-easymotion'
  " }}}

  " {{{ VimLSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  " Plug 'RishabhRD/popfix'
  " Plug 'RishabhRD/nvim-lsputils'
  " Plug 'prabirshrestha/vim-lsp'
  " Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/async.vim'
  " Plug 'prabirshrestha/asyncomplete.vim'
  " Plug 'prabirshrestha/asyncomplete-lsp.vim'
  " let g:lsp_diagnostics_echo_cursor = 1
  " let g:lsp_diagnostics_enabled = 1
  " let g:lsp_diagnostics_float_cursor = 1
  " let g:lsp_virtual_text_enabled = 0
  " " let g:lsp_documentation_float = 0
  " let g:lsp_signs_error = {'text': '✗'}
  " let g:lsp_signs_warning = {'text': '‼'}
  " let g:lsp_signs_hint = {'text': '?'}
  " hi! LspInformationText ctermfg=239 ctermbg=3
  " hi! LspHintText ctermfg=239 ctermbg=3
  " Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " }}}

  " {{{ Javascript
  Plug 'HerringtonDarkholme/yats.vim'
  " }}}

  " {{{ Graphql
  Plug 'jparise/vim-graphql', {'for': ['typescript', 'javascript', 'typescriptreact', 'javascriptreact']}
  " }}}

  " {{{ Rust
  Plug 'rust-lang/rust.vim', {'for': ['rust']}
  " }}}

  " {{{ Fish
  Plug 'dag/vim-fish'
  " }}}

  " {{{ Smarty
  Plug 'blueyed/smarty.vim'
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
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  let g:fzf_colors = {
      \ 'prompt': ['fg', 'Type'],
      \ 'hl': ['fg', 'Type'],
      \ 'hl+': ['fg', 'Number'],
      \ }
  " }}}

  " {{{ VimFugitive
  Plug 'tpope/vim-fugitive'
  " }}}

  " {{{ VimDispatch
  Plug 'tpope/vim-dispatch'
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
  " }}}
call plug#end()

" vim: foldmethod=marker:foldlevel=0
