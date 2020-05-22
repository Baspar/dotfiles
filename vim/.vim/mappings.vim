" Keep visual selection
vnoremap < <gv
vnoremap > >gv

" */#/n/N
nmap * *zz
nmap # #zz
nmap n nzz
nmap N Nzz

" Change j/k to wrap correctly
nnoremap j gj
nnoremap k gk

" cgn/cgN
nnoremap c*  *``cgn
nnoremap c#  #``cgN
nnoremap c>* *``cgn<C-r><C-o>"
nnoremap c># #``cgN<C-r><C-o>"
nnoremap <Plug>PrependText* n".P:call repeat#set("\<Plug>PrependText*")<CR>
nnoremap c<*                *Ncgn<C-r>"<C-o>`[<C-o>:call repeat#set("\<Plug>PrependText*")<CR>
nnoremap <Plug>PrependText# n".P:call repeat#set("\<Plug>PrependText#")<CR>
nnoremap c<#                #cgN<C-r>"<C-o>`[<C-o>:call repeat#set("\<Plug>PrependText#")<CR>

" FZF
nnoremap \ :Buffers<CR>
nnoremap <tab> :FZF<CR>

" fileExplorer
" nnoremap - :sil execute "Ex ".expand('%:h')<CR>
map <C-e> :NERDTreeToggle<CR>

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
nnoremap <leader>< :tabN<CR>
nnoremap <leader>> :tabn<CR>
nnoremap <leader><CR> :tabe<CR>
nnoremap <leader>bd :bn<CR> :bd #<CR>

" Save  and exit
nnoremap <leader>s :noh<CR>:update<CR>
nnoremap <leader>w :noh<CR>:w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" Reload nvim config
nnoremap <leader>vr :source $MYVIMRC<CR>
nnoremap <leader>ve :tabe $MYVIMRC<CR>
nnoremap <leader>vm :tabe $HOME/.vim/mappings.vim<CR>
nnoremap <leader>vp :tabe $HOME/.vim/plugins.vim<CR>
nnoremap <leader>vc :tabe $HOME/.vim/config.vim<CR>

" Splits
nnoremap <leader>\| :vs<CR>
nnoremap <leader>_ :sp<CR>
nnoremap <leader>- :sp<CR>
nnoremap <C-w><C-w> <C-w>\|<C-w>_

" Remove highlight
nnoremap <C-l> :noh<CR>

" Plug
noremap <leader>pi :PlugInstall<CR>
noremap <leader>pu :PlugUpdate<CR>
noremap <leader>pc :PlugClean<CR>

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
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gB :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gp :set termwinsize=10x0<CR>:term git push<CR>
nnoremap <leader>gP :set termwinsize=10x0<CR>:term git pull<CR>

" Select all
nnoremap <leader>a ggVG

" Rgs
nnoremap <leader>F :Rg<space>
nnoremap <leader>f :set opfunc=ag_helper#look_for_block_op<CR>g@
nmap <leader>f<leader>f <leader>fiw
vnoremap <leader>f :<C-u>call ag_helper#look_for_block('`<', '`>')<CR>

" Duplicates
nnoremap <leader>d :set opfunc=duplicate#duplicate_op<CR>g@
nmap <leader>d<leader>d yyP
vnoremap <leader>d :<C-u>call duplicate#duplicate('`<', '`>')<CR>

" Repl-it
nnoremap <expr> <leader>r repl_it#normal_mode()
vnoremap <leader>r :<C-u>call repl_it#visual_mode()<CR>
nmap <leader>rr V<leader>r

" Vim-Lsp
" nmap [a :LspNextError<CR>
" nmap ]a :LspPreviousError<CR>
" nmap <silent> <localleader>i :LspImplementation<CR>
" nmap <silent> <localleader>r :LspReferences<CR>
" nmap <silent> <localleader><localleader> :LspHover<CR>
" nmap <silent> <localleader>R :LspRename<CR>

" ALE
" nmap [a :<C-u>ALEPreviousWrap<CR>
" nmap ]a :<C-u>ALENextWrap<CR>

" CocNvim
nmap [a <Plug>(coc-diagnostic-prev)
nmap ]a <Plug>(coc-diagnostic-next)
nmap <silent> <localleader>i <Plug>(coc-implementation)
nmap <silent> <localleader>r <Plug>(coc-references)
nmap <silent> <localleader><localleader> :call CocAction("doHover")<CR>
nmap <silent> <localleader>R <Plug>(coc-rename)

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
