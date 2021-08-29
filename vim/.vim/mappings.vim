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
function! OpenGitFilesIfGit()
  silent! !git rev-parse --is-inside-work-tree
  if v:shell_error == 0
    return ":GitFiles"
  else
    return ":FZF"
  endif
endfunction
nnoremap \ :Buffers<CR>
nnoremap <expr> <tab> OpenGitFilesIfGit()
nnoremap <s-tab> :FZF<CR>

" fileExplorer
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap - :NERDTreeFind<CR>
augroup CancelNERDTreeQ
  au!
  au FileType nerdtree unmap <buffer> q
augroup END

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
nnoremap <leader><CR> m0:tabe %<CR>`0
nnoremap <leader>bd :bn<CR> :bd #<CR>

" Save  and exit
nnoremap <leader>s :noh<CR>:update<CR>
nnoremap <leader>w :noh<CR>:w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" Clear highlight
nnoremap <C-l> :noh<CR>

" Reload nvim config
nnoremap <leader>vr :source $MYVIMRC<CR>
nnoremap <leader>vE :tabe $MYVIMRC<CR>
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vL :tabe $HOME/.vim/lsp.lua<CR>
nnoremap <leader>vl :e $HOME/.vim/lsp.lua<CR>
nnoremap <leader>vM :tabe $HOME/.vim/mappings.vim<CR>
nnoremap <leader>vm :e $HOME/.vim/mappings.vim<CR>
nnoremap <leader>vP :tabe $HOME/.vim/plugins.vim<CR>
nnoremap <leader>vp :e $HOME/.vim/plugins.vim<CR>
nnoremap <leader>vC :tabe $HOME/.vim/config.vim<CR>
nnoremap <leader>vc :e $HOME/.vim/config.vim<CR>

" Splits
nnoremap <leader>\| :vs<CR>
nnoremap <leader>_ :sp<CR>
nnoremap <leader>- :sp<CR>
nnoremap <C-w><C-w> <C-w>\|<C-w>_

" Plug
noremap <leader>pi :PlugInstall<CR>
noremap <leader>pu :PlugUpdate<CR>
noremap <leader>pc :PlugClean<CR>

" Fugitive
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :call ToggleGStatus()<CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gm :Git move<Space>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Git blame<CR>
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

" Neovim LSP
nnoremap <silent> ]a :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> [a :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <localleader>i :Lspsaga lsp_finder<CR>
nnoremap <silent> <localleader>r :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <localleader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <localleader>f :lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <localleader><localleader> :Lspsaga code_action<CR>
vnoremap <silent> <localleader><localleader> :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent> <localleader>R :Lspsaga rename<CR>
nnoremap <silent> <localleader>p :Lspsaga preview_definition<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>

" Markdown
augroup MarkdownManipulation
  au!
  au FileType markdown nnoremap <buffer> <localleader>n :normal o- [-]<CR>hr jk
  au FileType markdown nnoremap <buffer> <localleader><localleader> :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[x\]<CR>:noh<CR>j
  au FileType markdown vmap <buffer> <localleader><localleader> :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[x\]<CR>:noh<CR>
  au FileType markdown nnoremap <buffer> <localleader><backspace> :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[ \]<CR>:noh<CR>j
  au FileType markdown vmap <buffer> <localleader><backspace> :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[ \]<CR>:noh<CR>
  au FileType markdown nnoremap <buffer> <localleader>w :s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[-\]<CR>:noh<CR>j
  au FileType markdown vmap <buffer> <localleader>w :'<,'>s/^\([^a-zA-Z0-9]*\)\[.\?\]/\1\[-\]<CR>:noh<CR>
augroup END

" Netrw
au FileType netrw nmap <buffer> o <CR>

" Add Move command (Visual / normal)
nnoremap <S-down> ddp
vnoremap <S-down> dpV`]
nnoremap <S-up> ddkP
vnoremap <S-up> dkPV`]

" No Highlight + clear trailing space
nnoremap <C-l> :noh<CR>

" Highlight helper
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" vim-test
nmap <silent> <localleader>tn :TestNearest<CR>
nmap <silent> <localleader>tf :TestFile<CR>
nmap <silent> <localleader>ts :TestSuite<CR>
nmap <silent> <localleader>tt :let g:test#scala#blooptest#project_name = ''<Left>
