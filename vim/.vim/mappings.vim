" Slime
xmap <localleader>s <Plug>SlimeRegionSend
nnoremap <localleader>s <Plug>SlimeMotionSend
nnoremap <localleader>ss <Plug>SlimeLineSend

" Keep visual selection
vnoremap < <gv
vnoremap > >gv

" cgn/cgN
nnoremap c* *Ncgn
nnoremap c# #NcgN

" Triple global indent
nnoremap <leader>f :Autoformat<CR>

" Instant Markdown
nnoremap <leader>M :InstantMarkdownPreview<CR>

" CTRL-P
nnoremap \ :Buffers<cr>
nnoremap <bar> :FZF<cr>

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
noremap <up> <C-w><up>
noremap <down> <C-w><down>
noremap <left> <C-w><left>
noremap <right> <C-w><right>
"
" Clipboard usage
noremap <leader>cy "+y
noremap <leader>cP "+P
noremap <leader>cp "+p
noremap <leader>cd "+d

" Buffer navigation
nnoremap <leader>< :bN<CR>
nnoremap <leader>> :bn<CR>
nnoremap <leader>bd :bn<CR> :bd #<CR>
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
nnoremap <Leader>E :edit $MYVIMRC<CR>

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
nnoremap <leader>A :Ag<cr>

" Ale
nnoremap [a <Plug>(ale_previous_wrap)
nnoremap ]a <Plug>(ale_next_wrap)

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
