call plug#begin('~/.vim/plugged')
    " {{{ Assist
        " {{{ Autoclosing
        Plug 'ntpeters/vim-better-whitespace'
        Plug 'jiangmiao/auto-pairs'
        Plug 'alvan/vim-closetag'
        " }}}
        " {{{ Syntax
        Plug 'tomtom/tcomment_vim'
        Plug 'tommcdo/vim-lion'
        Plug 'tpope/vim-abolish'
        " }}}
        " {{{ Navigation
        Plug 'scrooloose/nerdtree'
        Plug 'baspar/vim-cartographe'
        Plug 'easymotion/vim-easymotion'
        " }}}
        " {{{ LSP

        " Plug 'neoclide/coc.nvim', {'do': 'yarn install'}

        Plug 'prabirshrestha/async.vim'
        Plug 'prabirshrestha/vim-lsp'
        Plug 'prabirshrestha/asyncomplete.vim'
        Plug 'prabirshrestha/asyncomplete-lsp.vim'

        " Plug 'neovim/nvim-lsp'
        " Plug 'haorenW1025/completion-nvim'
        " Plug 'haorenW1025/diagnostic-nvim'
        " }}}
    " }}}

    " {{{ Languages
        " {{{ Syntax
        " Plug 'sheerun/vim-polyglot'
        Plug 'MaxMEllon/vim-jsx-pretty', {'for': ['typescript', 'javascript', 'typescriptreact', 'javascriptreact']}
        Plug 'pangloss/vim-javascript'
        Plug 'leafgarland/typescript-vim'
        " }}}
        " {{{ Javascript/React.JS
        Plug 'jparise/vim-graphql'
        " }}}
        " {{{ Rust
        Plug 'rust-lang/rust.vim', {'for': ['rust']}
        " }}}
        " {{{ Clojure
        Plug 'guns/vim-sexp', {'for': ['clojure']}
        Plug 'guns/vim-clojure-static', {'for': ['clojure']}
        Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': ['clojure']}
        " }}}
    " }}}

    " {{{ Utils
        " {{{ Undo
        Plug 'mbbill/undotree'
        " }}}
        " {{{ File
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " }}}
        " {{{ Git
        Plug 'tpope/vim-fugitive'
        Plug 'tpope/vim-dispatch'
        " }}}
        " {{{ Text Object
        Plug 'machakann/vim-sandwich'
        " }}}
    " }}}

    " {{{ UI
        " {{{ Colorschemes
        Plug 'fcpg/vim-fahrenheit'
        Plug 'AlessandroYorba/alduin'
        Plug 'fcpg/vim-orbital'
        Plug 'fcpg/vim-farout'
        " }}}
        " {{{ Statusline
        Plug 'itchyny/lightline.vim'
        " }}}
    " }}}
call plug#end()

" vim: foldmethod=marker:foldlevel=1
