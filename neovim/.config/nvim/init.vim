set nocompatible
set encoding=utf8
syntax on
filetype plugin on
set number
set relativenumber
set mouse=a
let mapleader=","
let maplocalleader=" "
set nowrap
set hlsearch
set incsearch
set undofile
set undodir=$HOME/.config/nvim/undo
set undolevels=1000
set undoreload=10000
set hidden
set foldmethod=syntax

" Function
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
command ToggleGStatus :call ToggleGStatus()


" Indentation
autocmd FileType javascript set tabstop=2 shiftwidth=2 expandtab
autocmd FileType css set tabstop=2 shiftwidth=2 expandtab
set tabstop=4 shiftwidth=4 expandtab

" Custom key map
    " Triple global indent
    map <leader>f :Autoformat<CR>

    " NerdTree
    map <C-e> :NERDTreeToggle<CR>
    map <leader>e :NERDTreeToggle<CR>

    " Undo Tree
    map <C-u> :UndotreeToggle<CR>
    map <leader>u :UndotreeToggle<CR>

    " Disable arrow keys
    imap <up> <nop>
    imap <down> <nop>
    imap <left> <nop>
    imap <right> <nop>
    map <up> <nop>
    map <down> <nop>
    map <left> <nop>
    map <right> <nop>

    " Buffer navigation
    map <leader>< :bN<CR>
    map <leader>> :bn<CR>
    map <leader>bd :bn<CR> :bd #<CR>
    nnoremap <Leader>s :update<CR>
    nnoremap <Leader>w :w<CR>
    nnoremap <leader>q :q<CR>
    nnoremap <leader>Q :q!<CR>

    " Split nav
    nnoremap <C-Down> <C-w>j
    nnoremap <C-Up> <C-w>k
    nnoremap <C-Left> <C-w>h
    nnoremap <C-Right> <C-w>l

    " TagBar
    map <Leader>B :TagbarToggle<CR>

    " Terminal
    nnoremap <Leader>t :terminal<CR>

    " Neoterm
    autocmd FileType clojure map <buffer> <Leader>zz :normal mava)<CR> :TREPLSendSelection<CR>`a
    nnoremap <Leader>Z :normal maV<CR> :TREPLSendSelection<CR>`a

    " Reload nvim config
    nnoremap <Leader>R :source ~/.config/nvim/init.vim<CR>
    nnoremap <Leader>O :edit ~/.vimrc<CR>

    " Splits
    nnoremap <Leader>\| :vs<CR>
    nnoremap <Leader>_ :sp<CR>

    " Remove highlight
    nnoremap <esc> :noh<CR><esc>

    " Tabular
    noremap <Leader>pi :PlugInstall<CR>
    noremap <Leader>pu :PlugUpdate<CR>
    noremap <Leader>pc :PlugClean<CR>

    " Tabular
    noremap <Leader>T :Tabular /

    " Fugitive
    nnoremap <leader>ga :Git add %:p<CR><CR>
    " nnoremap <leader>gs :Gstatus<CR>
    nnoremap <leader>gs :ToggleGStatus<CR>
    nnoremap <leader>gc :Gcommit -v -q<CR>
    nnoremap <leader>gt :Gcommit -v -q %:p<CR>
    nnoremap <leader>gd :Gdiff<CR>
    nnoremap <leader>ge :Gedit<CR>
    nnoremap <leader>gr :Gread<CR>
    nnoremap <leader>gw :Gwrite<CR><CR>
    nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
    nnoremap <leader>gp :Ggrep<Space>
    nnoremap <leader>gm :Gmove<Space>
    nnoremap <leader>gb :Git branch<Space>
    nnoremap <leader>go :Git checkout<Space>
    nnoremap <leader>gps :Dispatch! git push<CR>
    nnoremap <leader>gpl :Dispatch! git pull<CR>

    " Goyo
    " nnoremap <leader>G :Goyo<CR>
    nnoremap <leader>G :Goyo<CR>:Limelight!!<CR>

    " Select line
    nnoremap <leader>l :normal ^v$<cr>

    " Select all
    nnoremap <leader>A :normal ggVG<cr>
    nnoremap <leader>a :normal ggVG<cr>

    " Smooth Scoll
    noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
    noremap <silent> <PageUp> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
    noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>
    noremap <silent> <PageDown> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>

    " Vim-Go
    au FileType go nmap <localleader>gr <Plug>(go-run)
    au FileType go nmap <localleader>gb <Plug>(go-build)
    au FileType go nmap <localleader>gt <Plug>(go-test)
    au FileType go nmap <localleader>gc <Plug>(go-coverage)
    au FileType go nmap <localleader>gd <Plug>(go-doc)
    au FileType go nmap <localleader>ge <Plug>(go-rename)
    au FileType go nmap <localleader>gi <Plug>(go-info)

call plug#begin('~/.config/nvim/plugged')
    " Colorschemes
    Plug 'AlessandroYorba/alduin'
    Plug 'AlessandroYorba/Sierra'
    Plug 'AlessandroYorba/Despacio'
    Plug 'morhetz/gruvbox'

    " Syntax
    Plug 'w0rp/ale'
    let g:ale_linters = {
                \   'javascript': ['standard'],
                \}
    Plug 'Chiel92/vim-autoformat'

    " CTRL P
    Plug 'ctrlpvim/ctrlp.vim'
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

    " TAGBAR
    Plug 'majutsushi/tagbar'

     " NERDTREE
    Plug 'ryanoasis/vim-devicons'
        let g:webdevicons_conceal_nerdtree_brackets = 0
        let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
        let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0
    Plug 'scrooloose/nerdtree'
        autocmd StdinReadPre * let s:std_in=1
        " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'low-ghost/nerdtree-fugitive'


    " Javascript/React.JS
    Plug 'othree/yajs.vim'
    Plug 'alvan/vim-closetag'
        let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js"
    Plug 'mattn/emmet-vim'
    Plug 'fleischie/vim-styled-components'
    " Plug 'pangloss/vim-javascript'
    " Plug 'maxmellon/vim-jsx-pretty'


    " CLOJURE
    " Plug 'neovim/node-host'
    " Plug 'clojure-vim/nvim-parinfer.js'
    Plug 'guns/vim-sexp'
    Plug 'guns/vim-clojure-static'
        let g:clojure_align_multiline_strings = 1
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
        let g:sexp_insert_after_wrap = 'false'

    " GOLANG
    Plug 'fatih/vim-go'
        let g:go_fmt_command = "goimports"

    " AIRLINE
    Plug 'vim-airline/vim-airline'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        " let g:airline_theme='distinguished'
        let g:airline_theme='ubaryd'
        set laststatus=2
    Plug 'vim-airline/vim-airline-themes'

    " Text obj
    Plug 'kana/vim-textobj-user'
    " Plug 'kana/vim-textobj-line'
    Plug 'wellle/targets.vim'

    " MARKDOWN
    Plug 'tpope/vim-markdown'
    Plug 'suan/vim-instant-markdown'
    " Plug 'JamshedVesuna/vim-markdown-preview'
    "     let vim_markdown_preview_github=1

    " GIT
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Misc
    Plug 'tpope/vim-abolish'
    Plug 'machakann/vim-sandwich'
    Plug 'ntpeters/vim-better-whitespace'
        autocmd BufWritePre * StripWhitespace
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
        let g:limelight_conceal_ctermfg = 'gray'
        let g:limelight_conceal_ctermfg = 240

    Plug 'terryma/vim-smooth-scroll'
    Plug 'kassio/neoterm'
    Plug 'godlygeek/tabular'
    Plug 'Townk/vim-autoclose'
    Plug 'alvan/vim-closetag'
    Plug 'tomtom/tcomment_vim'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-go', { 'do': 'make'}
    Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'mbbill/undotree'

    " Love-Hate group
    " Plug 'flazz/vim-colorschemes'
    " Plug 'easymotion/vim-easymotion'
    " Plug 'tpope/vim-fireplace'
    " Plug 'ctford/vim-fireplace-easy'
    " Plug 'kopischke/vim-stay'
    " Plug 'kana/vim-textobj-user'
    " Plug 'michaeljsmith/vim-indent-object'
    " Plug 'glts/vim-textobj-comment'
    " Plug 'derekwyatt/vim-scala'
call plug#end()

let g:indentLine_color_term = 0
colorscheme alduin
let g:deoplete#enable_at_startup = 1
au FileType javascript,jsx setl omnifunc=tern#Complete
