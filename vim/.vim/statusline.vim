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
func! s:is_undo(filename)
    return a:filename =~# '^undotree'
endfunc
func! s:is_diff(filename)
    return a:filename =~# '^diffpanel'
endfunc

" Component functions
func! LSPDiagnosticCount(level)
  if has('nvim') && luaeval('not vim.tbl_isempty(vim.lsp.get_clients({bufnr = 0}))')
    return luaeval("table.getn(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.".a:level." }))")
  endif
  return 0
endfunc

func! LineInfo()
    let filename = expand('%:f')
    if s:is_nerd_tree(filename)
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

augroup UpdateStatusLine
  set fillchars=stl:━,stlnc:╍

  function! s:update_status_line_highlights()
    hi! link StatusLineFileName LineNr
    hi! link StatusLineLineInfo StatusLineFileName
    hi! link StatusLine LineNr
    hi StatusLine ctermbg=NONE guibg=NONE
    hi! link StatusLineNC StatusLine
    hi! link VertSplit WinSeparator

    if &background ==# "dark"
      hi! StatusLineModeCommand ctermbg=yellow ctermfg=black guibg=#AF875F guifg=#3E3E3E gui=bold
    else
      hi! StatusLineModeCommand ctermbg=brown  ctermfg=white guibg=#7C6F65 guifg=#FBF0C9 gui=bold
    endif

    hi! link StatusLineLspError Red
    hi! link StatusLineLspWarning Yellow
    hi! link StatusLineLspInfo Green
  endfunction

  function! s:set_status_line_active()
    setlocal statusline=%#StatusLineModeCommand#
    setlocal statusline+=\ %{Mode()}\ 
    setlocal statusline+=%#StatusLineFileName#
    setlocal statusline+=\ %f
    setlocal statusline+=%m\ 
    setlocal statusline+=%#VertSplit#
    setlocal statusline+=%=

    setlocal statusline+=%#StatusLineLspError#
    setlocal statusline+=%{LSPDiagnosticCount(\"ERROR\")>0?'⠀':''}
    setlocal statusline+=%{LSPDiagnosticCount(\"ERROR\")>0?LSPDiagnosticCount(\"ERROR\"):''}
    setlocal statusline+=%{LSPDiagnosticCount(\"ERROR\")>0?'⠀':''}

    setlocal statusline+=%#StatusLineLspWarning#
    setlocal statusline+=%{LSPDiagnosticCount(\"WARN\")>0?'⠀':''}
    setlocal statusline+=%{LSPDiagnosticCount(\"WARN\")>0?LSPDiagnosticCount(\"WARN\"):''}
    setlocal statusline+=%{LSPDiagnosticCount(\"WARN\")>0?'⠀':''}

    setlocal statusline+=%#StatusLineLspInfo#
    setlocal statusline+=%{LSPDiagnosticCount(\"INFO\")>0?'⠀':''}
    setlocal statusline+=%{LSPDiagnosticCount(\"INFO\")>0?LSPDiagnosticCount(\"INFO\"):''}
    setlocal statusline+=%{LSPDiagnosticCount(\"INFO\")>0?'⠀':''}

    setlocal statusline+=%#StatusLineLineInfo#
    setlocal statusline+=\ %{LineInfo()}\ 
    setlocal statusline+=%#StatusLineModeCommand#
    setlocal statusline+=\ %{Fugitive()}\ 
  endfunction

  function! s:set_status_line_inactive()
    setlocal statusline=%#StatusLineFileName#
    setlocal statusline+=\ %f
    setlocal statusline+=%m\ 
    setlocal statusline+=%#VertSplit#
    setlocal statusline+=%=
  endfunction

  function! s:set_status_line_simple()
    setlocal statusline=%#StatusLineModeCommand#
    setlocal statusline+=\ %{FileName()}\ 
    setlocal statusline+=%#Normal#
  endfunction

  function! s:update_status_line(active)
    call s:update_status_line_highlights()

    let filename = expand('%:f')
    if s:is_nerd_tree(filename) || s:is_undo(filename) || s:is_diff(filename)
      call s:set_status_line_simple()
    elseif a:active
      call s:set_status_line_active()
    else
      call s:set_status_line_inactive()
    endif
  endfunction

  au!
  au ColorScheme * call s:update_status_line(v:true)
  au VimEnter * call s:update_status_line(v:true)
  au FocusLost,WinLeave,BufLeave * call s:update_status_line(v:false)
  au FocusGained,BufWinEnter,WinEnter,WinNew,BufEnter * call s:update_status_line(v:true)
  au InsertLeave * call s:update_status_line(v:true)
  au InsertChange * call s:update_status_line(v:true)
  au InsertEnter * call s:update_status_line(v:true)
  au User CustomColors,NerdTreeOpen call s:update_status_line(v:true)

augroup END
