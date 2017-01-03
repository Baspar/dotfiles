nnoremap <Space> <Nop>

set nocompatible
set encoding=utf8
syntax on
set number
set relativenumber
set mouse=a
let mapleader=","
let maplocalleader=" "
set tabstop=4 shiftwidth=4 expandtab
set nowrap
set hlsearch
set undofile
set undodir=$HOME/.config/nvim/undo " where to save undo histories
set undolevels=1000
set undoreload=10000
set hidden                  " manage effectively buffe
runtime macros/matchit.vim  " more match possibilities


" Custom key map
    " NerdTree
    map <C-e> :NERDTreeToggle<CR>
    map <leader>e :NERDTreeToggle<CR>

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
    map <S-Left> :bN<CR>
    map <S-Right> :bn<CR>
    map <S-Down> :bp<CR> :bd #<CR>
    nnoremap <Leader>s :update<CR>
    nnoremap <leader>q :q<CR>
    nnoremap <leader>Q :q!<CR>

    " Terminal (FIXME)
    nnoremap <Leader>t :terminal<CR>
    " nnoremap <Leader>ft :tabe<CR> :terminal<CR>

    " Reload nvim config
    nnoremap <Leader>R :source ~/.config/nvim/init.vim<CR>

    " Splits
    nnoremap <Leader>\| :vs<CR>
    nnoremap <Leader>_ :sp<CR>

    " Remove highlight
    nnoremap <esc> :noh<CR><esc>

    " Tabular
    noremap <Leader>T :Tabular /

    " Fugitive
    nnoremap <leader>ga :Git add %:p<CR><CR>
    nnoremap <leader>gs :Gstatus<CR>
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
    nnoremap <leader>G :Goyo<cr>

	" Smooth Scoll
	noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
	noremap <silent> <PageUp> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
	noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>
	noremap <silent> <PageDown> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>


call plug#begin('~/.config/nvim/plugged')
    Plug 'flazz/vim-colorschemes'
    Plug 'godlygeek/tabular'
    " Plug 'kana/vim-textobj-user'
    " Plug 'jiangmiao/auto-pairs'
    " Plug 'michaeljsmith/vim-indent-object'
    " Plug 'glts/vim-textobj-comment'
    Plug 'tomtom/tcomment_vim'

    " CTRL P
    Plug 'ctrlpvim/ctrlp.vim'
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

     " NERDTREE
    Plug 'ryanoasis/vim-devicons'
        let g:webdevicons_conceal_nerdtree_brackets = 0
        let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
        let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0
    Plug 'scrooloose/nerdtree'
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    Plug 'Xuyuanp/nerdtree-git-plugin'


    Plug 'Townk/vim-autoclose'
    Plug 'mxw/vim-jsx'
        let g:jsx_ext_required = 0

    " CLOJURE
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
    Plug 'guns/vim-sexp'
    Plug 'luochen1990/rainbow'
        let g:rainbow_active = 1

    " AIRLINE
    Plug 'vim-airline/vim-airline'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        let g:airline_theme='distinguished'
        set laststatus=2
    Plug 'vim-airline/vim-airline-themes'

    " MARKDOWN
    Plug 'tpope/vim-markdown'
    Plug 'suan/vim-instant-markdown'

    " GIT
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Plug 'easymotion/vim-easymotion'
    " Plug 'tpope/vim-fireplace'
    " Plug 'ctford/vim-fireplace-easy'
    " Plug 'kopischke/vim-stay'
    Plug 'tpope/vim-surround'
    Plug 'ntpeters/vim-better-whitespace'
        autocmd BufWritePre * StripWhitespace
    Plug 'junegunn/goyo.vim'
    Plug 'terryma/vim-smooth-scroll'
    Plug 'yggdroot/indentline'
    Plug 'ElmCast/elm-vim'
call plug#end()

" colorscheme Tomorrow-Night
let g:indentLine_color_term = 0
colorscheme alduin
