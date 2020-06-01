let &t_ti.="\e[?7727h"
let &t_te.="\e[?7727l"
set inccommand=nosplit
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set winblend=5
set pumblend=5

function! FloatingFZF(n)
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = float2nr(&lines * (a:n - 1) / a:n)
    let width = float2nr(&columns * (a:n - 1) / a:n)
    let col = float2nr((&columns - width) / 2)
    let row = float2nr((&lines - height) / 2)

    let opts = {
                \ 'relative': 'editor',
                \ 'row': row,
                \ 'col': col,
                \ 'width': width,
                \ 'height': height,
                \ 'style': 'minimal'
                \ }

    call nvim_open_win(buf, v:true, opts)
endfunction

let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_preview_window = ''
let g:fzf_layout = { 'window': 'call FloatingFZF(2)' }

command! -bang -nargs=* Rg call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'window': 'call FloatingFZF(10)'}, 'down:40%'), <bang>0)
