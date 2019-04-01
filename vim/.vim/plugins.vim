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
        " }}}
        " {{{ Navigation
        Plug 'easymotion/vim-easymotion'
        " }}}
        " {{{ LSP
        Plug 'neoclide/coc.nvim', {'do': 'yarn install'}
        " }}}
    " }}}

    " {{{ Languages
        " {{{ Javascript/React.JS
        Plug 'alvan/vim-closetag'
        Plug 'sheerun/vim-polyglot'
        " }}}
        " {{{ Rust
        Plug 'rust-lang/rust.vim'
        " }}}
        " {{{ Clojure
        Plug 'guns/vim-sexp'
        Plug 'guns/vim-clojure-static'
        Plug 'tpope/vim-sexp-mappings-for-regular-people'
        " }}}
        " {{{ Markdown
        " }}}
    " }}}

    " {{{ Utils
        " {{{ Undo
        Plug 'mbbill/undotree'
        Plug 'tpope/vim-repeat'
        " }}}
        " {{{ File
        Plug 'scrooloose/nerdtree'
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " }}}
        " {{{ Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'
        Plug 'rbong/vim-flog'
        " }}}
        " {{{ Text Object
        Plug 'machakann/vim-sandwich'
        Plug 'machakann/vim-highlightedyank'
        Plug 'xtal8/traces.vim'
        Plug 'kana/vim-textobj-user'
        Plug 'beloglazov/vim-textobj-quotes'
        " }}}
        " {{{ Async
        Plug 'tpope/vim-dispatch'
        " }}}
    " }}}

    " {{{ UI
        " {{{ Colorschemes
        Plug 'AlessandroYorba/alduin'
        " }}}
        " {{{ Airline
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        " }}}
        " {{{ Goyo
        Plug 'junegunn/goyo.vim'
        Plug 'junegunn/limelight.vim'
        " }}}
    " }}}
call plug#end()

" vim: foldmethod=marker:foldlevel=1
