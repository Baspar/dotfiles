function! repl_it#get_tmux_pane(count)
  let panes = system('tmux list-panes')
  let panes = trim(panes)
  let panes = split(panes, '\n')
  let panes = filter(panes, 'v:val !~ ".*(active)"')
  let panes = map(panes, "split(v:val, ' ')[-1]")
  let pane = panes[a:count]
  return pane
endfunction

function! repl_it#send(pane, text)
  execute 'silent! !tmux send-keys -l -t "\' . a:pane . '" "' . a:text . '"'
  execute 'silent! !tmux send-keys -t "\' . a:pane . '" Enter'
endfunction

function! repl_it#send_to(type, ...)
  let pane = g:repl_it_pane
  if a:type == 'line'
    execute "normal! '[V']\"ry"
  elseif a:type == 'char'
    execute "normal! `[v`]\"ry"
  else
    execute "normal! `<v`>\"ry"
  endif

  let text = trim(@r)
  let text = escape(text, '$"%#;')

  for block in split(text, '\n')
    call repl_it#send(pane, block)
  endfor
endfunction

function! repl_it#normal_mode()
  let g:repl_it_pane = repl_it#get_tmux_pane(v:count)
  let g:repl_it_from_mark = '['
  let g:repl_it_to_mark = ']'
  set opfunc=repl_it#send_to
  return 'g@'
endfunction

function! repl_it#visual_mode()
  let g:repl_it_pane = repl_it#get_tmux_pane(v:count)
  let g:repl_it_from_mark = '<'
  let g:repl_it_to_mark = '>'
  call repl_it#send_to(visualmode(), 1)
endfunction

function! repl_it#send_text(text)
  let pane = repl_it#get_tmux_pane(v:count)
  call repl_it#send(pane, a:text)
endfunction
