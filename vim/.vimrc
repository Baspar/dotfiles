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
set foldmethod=indent
set wildmenu

" TO BE CHANGED

" set termguicolors
set t_Co=256

" Function
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction

" Indentation
set tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript,jsx set tabstop=2 shiftwidth=2 expandtab
autocmd FileType css set tabstop=2 shiftwidth=2 expandtab

" Custom key map
" Keep visual selection
vnoremap < <gv
vnoremap > >gv

" Triple global indent
nmap <leader>f :Autoformat<CR>

" Instant Markdown
let g:instant_markdown_autostart = 0
nnoremap <leader>M :InstantMarkdownPreview<CR>

" CTRL-P
nnoremap \ :FZF<cr>

" NerdTree
map <C-e> :NERDTreeToggle<CR>
nmap <leader>e :NERDTreeToggle<CR>

" Undo Tree
map <C-u> :UndotreeToggle<CR>
nmap <leader>u :UndotreeToggle<CR>

" Disable arrow keys
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
"
" Clipboard usage
noremap <leader>cy "+y
noremap <leader>cP "+P
noremap <leader>cp "+p
noremap <leader>cd "+d

" Buffer navigation
nmap <leader>< :bN<CR>
nmap <leader>> :bn<CR>
nmap <leader>bd :bn<CR> :bd #<CR>
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
nnoremap <Leader>t :set termsize=0x0<CR>:terminal<CR>

" Neoterm
autocmd FileType clojure map <buffer> <Leader>zz :normal mava)<CR> :TREPLSendSelection<CR>`a
nnoremap <Leader>Z :normal maV<CR> :TREPLSendSelection<CR>`a

" Reload nvim config
nnoremap <Leader>R :source $MYVIMRC<CR>
nnoremap <Leader>O :edit $MYVIMRC<CR>

" Splits
nnoremap <Leader>\| :vs<CR>
nnoremap <Leader>_ :sp<CR>
nnoremap <Leader>- :sp<CR>

" Remove highlight
nnoremap <leader><esc> :noh<CR><esc>

" Tabular
noremap <Leader>pi :PlugInstall<CR>
noremap <Leader>pu :PlugUpdate<CR>
noremap <Leader>pc :PlugClean<CR>

" Tabular
noremap <Leader>T :Tabular /

" Fugitive
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :call ToggleGStatus()<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gb :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gp :set termsize=10x0<CR>:term git push<CR>
nnoremap <leader>gP :set termsize=10x0<CR>:term git pull<CR>

" Goyo
nnoremap <leader>G :Goyo<CR>:hi Normal guibg=NONE ctermbg=NONE<CR>
nnoremap <leader>L :Limelight!!<CR>

" Select line
nnoremap <leader>l :normal ^v$<cr>

" Select all
nnoremap <leader>a :normal ggVG<cr>

" Ags
nnoremap <leader>A :Ag<Space>

" Smooth Scoll
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
noremap <silent> <PageUp> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>
noremap <silent> <PageDown> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>

" Ale
nmap [a <Plug>(ale_previous_wrap)
nmap ]a <Plug>(ale_next_wrap)

" Vim-Go
au FileType go nmap <localleader>gr <Plug>(go-run)
au FileType go nmap <localleader>gb <Plug>(go-build)
au FileType go nmap <localleader>gt <Plug>(go-test)
au FileType go nmap <localleader>gc <Plug>(go-coverage)
au FileType go nmap <localleader>gd <Plug>(go-doc)
au FileType go nmap <localleader>ge <Plug>(go-rename)
au FileType go nmap <localleader>gi <Plug>(go-info)

au FileType clojure nmap <localleader>ct magg/dayyw`a,:!clear; lein test "


" Markdown
au FileType markdown nmap <localleader>n :normal o- [-]<CR>hr jk
au FileType markdown nmap <localleader><localleader> :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[x\]<CR>:noh<CR>j
au FileType markdown vmap <localleader><localleader> :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[x\]<CR>:noh<CR>
au FileType markdown nmap <localleader><backspace> :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[ \]<CR>:noh<CR>j
au FileType markdown vmap <localleader><backspace> :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[ \]<CR>:noh<CR>
au FileType markdown nmap <localleader>w :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[-\]<CR>:noh<CR>j
au FileType markdown vmap <localleader>w :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[-\]<CR>:noh<CR>
"
call plug#begin('~/.config/nvim/plugged')
    " Colorschemes
    Plug 'AlessandroYorba/alduin'
    Plug 'AlessandroYorba/Sierra'
    Plug 'AlessandroYorba/Despacio'
    Plug 'morhetz/gruvbox'

    " Syntax
    Plug 'w0rp/ale'
    let g:ale_linters = {'javascript': ['standard']}

    Plug 'xtal8/traces.vim'
    " CTRL P
    " Plug 'ctrlpvim/ctrlp.vim'
    " let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    Plug 'junegunn/fzf.vim'

    " NERDTREE
    Plug 'ryanoasis/vim-devicons'
    let g:webdevicons_conceal_nerdtree_brackets = 0
    let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
    let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0
    Plug 'scrooloose/nerdtree'
    autocmd StdinReadPre * let s:std_in=1
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'low-ghost/nerdtree-fugitive'


    " Javascript/React.JS
    Plug 'alvan/vim-closetag'
    let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js"
    Plug 'sheerun/vim-polyglot'


    " CLOJURE
    Plug 'guns/vim-sexp'
    Plug 'guns/vim-clojure-static'
    let g:clojure_align_multiline_strings = 1
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
    let g:sexp_insert_after_wrap = 'false'

    " GOLANG
    " Plug 'fatih/vim-go'
    " let g:go_fmt_command = "goimports"

    " LIGHLINE
    Plug 'itchyny/lightline.vim'
    set laststatus=2
    set noshowmode
    let g:lightline = {'colorscheme': 'seoul256'}

    " Text obj
    Plug 'kana/vim-textobj-user'
    Plug 'beloglazov/vim-textobj-quotes'
    " Plug 'wellle/targets.vim'

    " MARKDOWN
    Plug 'tpope/vim-markdown'
    Plug 'suan/vim-instant-markdown'

    " GIT
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Misc
    Plug 'gabesoft/vim-ags'
    Plug 'machakann/vim-sandwich'
    Plug 'ntpeters/vim-better-whitespace'
    autocmd BufWritePre * StripWhitespace
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    let g:limelight_conceal_ctermfg = 'gray'
    let g:limelight_conceal_ctermfg = 240

    Plug 'easymotion/vim-easymotion'
    Plug 'godlygeek/tabular'
    Plug 'Townk/vim-autoclose'
    Plug 'alvan/vim-closetag'
    Plug 'tomtom/tcomment_vim'
    Plug 'mbbill/undotree'
call plug#end()

let g:indentLine_color_term = 0

" Color
colorscheme alduin
hi Normal guibg=NONE ctermbg=NONE
let g:deoplete#enable_at_startup = 1
au FileType javascript,jsx setl omnifunc=tern#Complete
