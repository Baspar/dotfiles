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
        Plug 'scrooloose/nerdtree'
        " }}}
        " {{{ LSP
        Plug 'neoclide/coc.nvim', {'do': 'yarn install'}
        " Plug 'prabirshrestha/asyncomplete.vim'
        " Plug 'prabirshrestha/async.vim'
        " Plug 'prabirshrestha/vim-lsp'
        " Plug 'prabirshrestha/asyncomplete-lsp.vim'
        " Plug 'dense-analysis/ale'
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
        Plug 'rust-lang/rust.vim'
        " }}}
        " {{{ Scala
        " Plug 'derekwyatt/vim-scala'
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
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " }}}
        " {{{ Git
        Plug 'tpope/vim-fugitive'
        Plug 'junegunn/gv.vim'
        " }}}
        " {{{ Text Object
        Plug 'machakann/vim-sandwich'
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
        " Plug 'morhetz/gruvbox'
        " Plug 'arzg/vim-substrata'
        " }}}
        " {{{ Airline
        Plug 'itchyny/lightline.vim'
        " }}}
        " {{{ Goyo
        Plug 'junegunn/goyo.vim'
        Plug 'junegunn/limelight.vim'
        " }}}
    " }}}
call plug#end()

" vim: foldmethod=marker:foldlevel=1
