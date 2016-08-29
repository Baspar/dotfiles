set encoding=utf8
syntax on
set number
set relativenumber
set mouse=a
let mapleader=","
set tabstop=4 shiftwidth=4 expandtab
colorscheme desert
set nowrap
set hlsearch
set undofile
set undodir=$HOME/.config/nvim/undo " where to save undo histories
set undolevels=1000
set undoreload=10000
set hidden                  " manage effectively buffe
runtime macros/matchit.vim  " more match possibilities


" Custom key map
    " Call to plugins
    map <C-e> :NERDTreeToggle<CR>
    map <C-S-g> :Grepper<CR>

    " Buffer navigation
    map <S-Left> :bN<CR>
    map <S-Right> :bn<CR>
    map <S-Down> :bp<CR> :bd #<CR>
    nnoremap <Leader>s :update<CR>
    nnoremap <leader>q :q<CR>
    nnoremap <leader>Q :q!<CR>

    " Terminal (TODO)
    nnoremap <Leader>t :terminal<CR>
    nnoremap <Leader>ft :tabe<CR> :terminal<CR>

    " Splits
    nnoremap <Leader>\| :vs<CR>
    nnoremap <Leader>_ :sp<CR>

    " Remove highlight
    nnoremap <esc> :noh<CR><esc>


call plug#begin('~/.config/nvim/plugged')
    "Plug 'Valloric/YouCompleteMe'
    Plug 'ctrlpvim/ctrlp.vim'
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    Plug 'salsifis/vim-transpose'

    Plug 'jiangmiao/auto-pairs'

    Plug 'mhinz/vim-grepper'
    Plug 'scrooloose/nerdcommenter'
    Plug 'scrooloose/nerdtree'
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'vim-scripts/paredit.vim'
    "Plug 'neovim/node-host'
    "Plug 'snoe/nvim-parinfer.js'
    "Plug 'bhurlow/vim-parinfer'
    Plug 'majutsushi/tagbar'
    Plug 'luochen1990/rainbow'
        let g:rainbow_active = 1
    Plug 'neomake/neomake'
        autocmd! BufWritePost * Neomake
    Plug 'vim-airline/vim-airline'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        let g:airline_theme='distinguished'
        set laststatus=2
    Plug 'vim-airline/vim-airline-themes'
    Plug 'easymotion/vim-easymotion'
    "Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-fugitive'
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
    Plug 'airblade/vim-gitgutter'
    Plug 'kopischke/vim-stay'
    Plug 'tpope/vim-surround'
    Plug 'ryanoasis/vim-devicons'
        let g:webdevicons_conceal_nerdtree_brackets = 0
        let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
        let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0
    Plug 'ntpeters/vim-better-whitespace'
        autocmd BufWritePre * StripWhitespace
    Plug 'tpope/vim-markdown'
call plug#end()
