" Slime
xmap <localleader>s <Plug>SlimeRegionSend
nnoremap <localleader>s <Plug>SlimeMotionSend
nnoremap <localleader>ss <Plug>SlimeLineSend

" Keep visual selection
vnoremap < <gv
vnoremap > >gv

" cgn/cgN
nnoremap c*  *Ncgn
nnoremap c#  #NcgN
nnoremap c>* *Ncgn<C-r>"
nnoremap c># #NcgN<C-r>"
nnoremap <Plug>PrependText* n".P:call repeat#set("\<Plug>PrependText*")<CR>
nnoremap c<*                *Ncgn<C-r>"<C-o>`[<C-o>:call repeat#set("\<Plug>PrependText*")<CR>
nnoremap <Plug>PrependText# n".P:call repeat#set("\<Plug>PrependText#")<CR>
nnoremap c<#                #cgN<C-r>"<C-o>`[<C-o>:call repeat#set("\<Plug>PrependText#")<CR>

" nnoremap <expr> c<* '*Ncgn<C-r>"'.repeat('<C-G>U<Left>',strlen(@"))
" nnoremap <expr> c<# '#NcgN<C-r>"'.repeat('<C-G>U<Left>',strlen(@"))

" Global indent
" nnoremap <leader>f :Autoformat<CR>

" Instant Markdown
nnoremap <leader>M :LivedownPreview<CR>

" CTRL-P
nnoremap \ :Buffers<CR>
nnoremap <tab> :FZF<CR>

" NerdTree
map <C-e> :NERDTreeToggle<CR>
nnoremap <leader>e :NERDTreeToggle<CR>

" Undo Tree
map <C-u> :UndotreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>

" Disable arrow keys
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Navigate split
noremap <up> <C-w><up>
noremap <down> <C-w><down>
noremap <left> <C-w><left>
noremap <right> <C-w><right>

" Clipboard usage
noremap <leader>cy "+y
noremap <leader>cP "+P
noremap <leader>cp "+p
noremap <leader>cd "+d

" Buffer navigation
nnoremap <leader>< :bN<CR>
nnoremap <leader>> :bn<CR>
nnoremap <leader>bd :bn<CR> :bd #<CR>
nnoremap <leader>s :noh<CR>:update<CR>
nnoremap <leader>w :noh<CR>:w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" Split nav
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k
nnoremap <C-Left> <C-w>h
nnoremap <C-Right> <C-w>l

" TagBar
map <leader>B :TagbarToggle<CR>

" Terminal
nnoremap <leader>t :set termwinsize=0x0<CR>:terminal<CR>

" Neoterm
autocmd FileType clojure map <buffer> <leader>zz :normal mava)<CR> :TREPLSendSelection<CR>`a
nnoremap <leader>Z :normal maV<CR> :TREPLSendSelection<CR>`a

" Reload nvim config
nnoremap <leader>vr :source $MYVIMRC<CR>
nnoremap <leader>ve :edit $MYVIMRC<CR>
nnoremap <leader>vm :edit $HOME/.vim/mappings.vim<CR>
nnoremap <leader>vp :edit $HOME/.vim/plugins.vim<CR>
nnoremap <leader>vc :edit $HOME/.vim/config.vim<CR>

" Splits
nnoremap <leader>\| :vs<CR>
nnoremap <leader>_ :sp<CR>
nnoremap <leader>- :sp<CR>

" Remove highlight
" nnoremap <leader><esc> :noh<CR><esc>

" Exit insert mode
inoremap jf <C-c>:noh<cr>
inoremap kj <C-c>:noh<cr>
inoremap jk <C-c>:noh<cr>

" Tabular
noremap <leader>pi :PlugInstall<CR>
noremap <leader>pu :PlugUpdate<CR>
noremap <leader>pc :PlugClean<CR>

" Tabular
noremap <leader>T :Tabular /

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
nnoremap <leader>gp :set termwinsize=10x0<CR>:term git push<CR>
nnoremap <leader>gP :set termwinsize=10x0<CR>:term git pull<CR>

" Goyo
nnoremap <leader>G :Goyo<CR>:hi Normal guibg=NONE ctermbg=NONE<CR>
nnoremap <leader>L :Limelight!!<CR>

" Select line
nnoremap <leader>l :normal ^v$<CR>

" Select all
nnoremap <leader>a :normal ggVG<CR>

" Ags
nnoremap <leader>A :Ag<space>

" Ale
nmap [a <Plug>(coc-diagnostic-prev)
nmap ]a <Plug>(coc-diagnostic-next)

" Vim-Go
au FileType go nnoremap <localleader>gr <Plug>(go-run)
au FileType go nnoremap <localleader>gb <Plug>(go-build)
au FileType go nnoremap <localleader>gt <Plug>(go-test)
au FileType go nnoremap <localleader>gc <Plug>(go-coverage)
au FileType go nnoremap <localleader>gd <Plug>(go-doc)
au FileType go nnoremap <localleader>ge <Plug>(go-rename)
au FileType go nnoremap <localleader>gi <Plug>(go-info)

" Avent of code - CLojure
au FileType clojure nnoremap <localleader>ct magg/dayyw`a,:!clear; lein test "

" Markdown
au FileType markdown nnoremap <localleader>n :normal o- [-]<CR>hr jk
au FileType markdown nnoremap <localleader><localleader> :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[x\]<CR>:noh<CR>j
au FileType markdown vmap <localleader><localleader> :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[x\]<CR>:noh<CR>
au FileType markdown nnoremap <localleader><backspace> :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[ \]<CR>:noh<CR>j
au FileType markdown vmap <localleader><backspace> :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[ \]<CR>:noh<CR>
au FileType markdown nnoremap <localleader>w :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[-\]<CR>:noh<CR>j
au FileType markdown vmap <localleader>w :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[-\]<CR>:noh<CR>

" Add Move command (Visual / normal)
nnoremap <S-down> ddp
vnoremap <S-down> dpV`]
vnoremap <S-up> dkPV`]
nnoremap <S-up> ddkP
