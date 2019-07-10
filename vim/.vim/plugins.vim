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
        Plug 'baspar/vim-cartographe'
        " }}}
        " {{{ LSP
        Plug 'neoclide/coc.nvim', {'do': 'yarn install'}
        " Plug 'prabirshrestha/vim-lsp'
        " }}}
    " }}}

    " {{{ Languages
        " {{{ Javascript/React.JS
        Plug 'sheerun/vim-polyglot'
        " }}}
        " {{{ Rust
        Plug 'rust-lang/rust.vim'
        " }}}
        " {{{ Scala
        Plug 'derekwyatt/vim-scala'
        " }}}
        " {{{ Clojure
        Plug 'guns/vim-sexp'
        Plug 'guns/vim-clojure-static'
        Plug 'tpope/vim-sexp-mappings-for-regular-people'
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
        Plug 'rbong/vim-flog'
        " }}}
        " {{{ Text Object
        Plug 'machakann/vim-sandwich'
        Plug 'machakann/vim-highlightedyank'
        " Plug 'xtal8/traces.vim'
        Plug 'kana/vim-textobj-user'
        Plug 'beloglazov/vim-textobj-quotes'
        " }}}
        " {{{ Async
        Plug 'tpope/vim-dispatch'
        Plug 'prabirshrestha/async.vim'
        " }}}
    " }}}

    " {{{ UI
        " {{{ Colorschemes
        Plug 'AlessandroYorba/alduin'
        " }}}
        " {{{ Airline
        " Plug 'vim-airline/vim-airline'
        " Plug 'vim-airline/vim-airline-themes'
        Plug 'itchyny/lightline.vim'
        " }}}
        " {{{ Goyo
        Plug 'junegunn/goyo.vim'
        Plug 'junegunn/limelight.vim'
        " }}}
    " }}}
call plug#end()

" vim: foldmethod=marker:foldlevel=1
