let s:mode_map = {
  \ 'n' : 'NORMAL',
  \ 'i' : 'INSERT',
  \ 'R' : 'REPLACE',
  \ 'v' : 'VISUAL',
  \ 'V' : 'V-LINE',
  \ "\<C-v>": 'V-BLOCK',
  \ 'c' : 'COMMAND',
  \ 's' : 'SELECT',
  \ 'S' : 'S-LINE',
  \ "\<C-s>": 'S-BLOCK',
  \ 't': 'TERMINAL',
  \ }

" Helper functions
func! s:is_nerd_tree(filename)
    return a:filename =~# '^NERD_tree_'
endfunc
func! s:is_fzf(filename)
    return a:filename =~# '^term://.*#FZF$'
endfunc
func! s:is_undo(filename)
    return a:filename =~# '^undotree'
endfunc
func! s:is_diff(filename)
    return a:filename =~# '^diffpanel'
endfunc

" Component functions
func! LSPWarning()
  if has('nvim') && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let count = luaeval("table.getn(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }))")
    if count != 0
      return count
    endif
  endif
  return ''
endfunc

func! LSPError()
  if has('nvim') && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let count = luaeval("table.getn(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }))")
    if count != 0
      return count
    endif
  endif
  return ''
endfunc

func! LineInfo()
    let filename = expand('%:f')
    if s:is_nerd_tree(filename)
        return ''
    elseif s:is_fzf(filename)
        return ''
    else
        return line('.') . '/' . line('$') . ':' . (col('$') - 1)
    endif
endfunc

func! FileName()
  let out = []

  let filename = expand('%:f')
  if filename == ''
    call add(out, '[No name]')
  else
    call add(out, filename)
  endif

  if &readonly
    call add(out, ' ')
  endif
  if &modified
    call add(out, '+')
  endif

  return join(out, '')
endfunc

func! Fugitive()
  if exists('*FugitiveHead') && FugitiveHead() != ''
    return FugitiveHead()
  endif
  return ''
endfunc

func! Mode()
  return get(s:mode_map, mode())
endfunc

" func! Wrap(text)
"   return get(s:mode_map, mode())
" endfunc

augroup UpdateStatusLine
  set fillchars=stl:─,stlnc:─

  function! s:update_status_line_highlights()
    if &background ==# "dark"
      hi! StatusLineModeCommand ctermbg=yellow ctermfg=black guibg=#af875f guifg=#3e3e3e gui=bold
      hi! link StatusLineFileName LineNr
      hi! StatusLineLspError ctermbg=red ctermfg=white guibg=#af5f5e guifg=#FFFFFF
      hi! StatusLineLspWarning ctermbg=yellow ctermfg=white guibg=#af875f guifg=#FFFFFF
      hi! link StatusLineLineInfo StatusLineFileName
    else
      hi! StatusLine ctermfg=brown guifg=#ebdab4
      hi! StatusLineModeCommand ctermbg=brown ctermfg=white guibg=#7c6f65 guifg=#fbf0c9 gui=bold
      hi! link StatusLineFileName LineNr
      hi! StatusLineLspError ctermbg=red ctermfg=white guibg=#af5f5e guifg=#FFFFFF
      hi! StatusLineLspWarning ctermbg=yellow ctermfg=white guibg=#af875f guifg=#FFFFFF
      hi! link StatusLineLineInfo StatusLineFileName
    endif
  endfunction

  function! s:set_status_line_active()
    setlocal statusline=
    setlocal statusline+=%#StatusLineModeCommand#
    setlocal statusline+=\ %{Mode()}\ 
    setlocal statusline+=%#StatusLineFileName#
    setlocal statusline+=\ %f
    setlocal statusline+=%m\ 
    setlocal statusline+=%#VertSplit#
    setlocal statusline+=%=
    setlocal statusline+=%#StatusLineLspError#
    setlocal statusline+=\ %{LSPError()}\ 
    setlocal statusline+=%#StatusLineLspWarning#
    setlocal statusline+=\ %{LSPWarning()}\ 
    setlocal statusline+=%#StatusLineLineInfo#
    setlocal statusline+=\ %{LineInfo()}\ 
    setlocal statusline+=%#StatusLineModeCommand#
    setlocal statusline+=\ %{Fugitive()}\ 
    setlocal statusline+=%#VertSplit#
  endfunction

  function! s:set_status_line_inactive()
    setlocal statusline=
    setlocal statusline+=%#StatusLineFileName#
    setlocal statusline+=\ %f
    setlocal statusline+=%m\ 
    setlocal statusline+=%#VertSplit#
    setlocal statusline+=%=
  endfunction

  function! s:set_status_line_simple()
    setlocal statusline=
    setlocal statusline+=%#StatusLineModeCommand#
    setlocal statusline+=\ %{FileName()}\ 
    setlocal statusline+=%#Normal#
  endfunction

  function! s:update_status_line(inactive)
    call s:update_status_line_highlights()

    let filename = expand('%:f')
    if s:is_nerd_tree(filename) || s:is_fzf(filename) || s:is_undo(filename) || s:is_diff(filename)
      call s:set_status_line_simple()
    elseif a:inactive
      call s:set_status_line_inactive()
    else
      call s:set_status_line_active()
    endif
  endfunction

  au!
  au ColorScheme * call s:update_status_line(v:false)
  au VimEnter * call s:update_status_line(v:false)
  au FocusLost,WinLeave,BufLeave * call s:update_status_line(v:true)
  au FocusGained,BufWinEnter,WinEnter,WinNew,BufEnter * call s:update_status_line(v:false)
  au InsertLeave * call s:update_status_line(v:false)
  au InsertChange * call s:update_status_line(v:false)
  au InsertEnter * call s:update_status_line(v:false)
  au User CustomColors call s:update_status_line(v:false)
augroup END
