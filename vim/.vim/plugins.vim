call plug#begin('~/.vim/plugged')
    " {{{ Assist
        " {{{ Autoclosing
        Plug 'ntpeters/vim-better-whitespace'
        Plug 'jiangmiao/auto-pairs'
        Plug 'alvan/vim-closetag'
        " }}}
        " {{{ Syntax
        Plug 'tomtom/tcomment_vim'
        Plug 'w0rp/ale'
        " }}}
        " {{{ Navigation
        Plug 'easymotion/vim-easymotion'
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
        Plug 'tpope/vim-markdown'
        Plug 'suan/vim-instant-markdown'
        " }}}
    " }}}

    " {{{ Utils
        " {{{ Undo
        Plug 'mbbill/undotree'
        " }}}
        " {{{ REPL
        Plug 'jpalardy/vim-slime'
        " }}}
        " {{{ File
        Plug 'scrooloose/nerdtree'
        Plug '/usr/local/opt/fzf'
        Plug 'junegunn/fzf.vim'
        " }}}
        " {{{ Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'
        " }}}
        " {{{ Text Object
        Plug 'machakann/vim-sandwich'
        Plug 'machakann/vim-highlightedyank'
        Plug 'xtal8/traces.vim'
        Plug 'kana/vim-textobj-user'
        Plug 'beloglazov/vim-textobj-quotes'
        " }}}
    " }}}

    " {{{ UI
        " {{{ Colorschemes
        Plug 'AlessandroYorba/alduin'
        Plug 'AlessandroYorba/Sierra'
        Plug 'AlessandroYorba/Despacio'
        Plug 'morhetz/gruvbox'
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
