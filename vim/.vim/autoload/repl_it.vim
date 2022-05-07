function! repl_it#get_tmux_pane(count)
  let panes = system('tmux list-panes')
  let panes = trim(panes)
  let panes = split(panes, '\n')
  let panes = filter(panes, 'v:val !~ ".*(active)"')
  let panes = map(panes, "split(v:val, ' ')[-1]")
  let pane = panes[a:count]
  return pane
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

  call system("tmux loadb -b replit -", getreg("r"))
  execute 'silent! !tmux pasteb -b replit -t "\' . pane . '"'
  execute 'silent! !tmux deleteb -b replit'
endfunction

function! repl_it#normal_mode()
  let g:repl_it_pane = repl_it#get_tmux_pane(v:count)
  set opfunc=repl_it#send_to
  return 'g@'
endfunction

function! repl_it#visual_mode()
  let g:repl_it_pane = repl_it#get_tmux_pane(v:count)
  call repl_it#send_to(visualmode(), 1)
endfunction
