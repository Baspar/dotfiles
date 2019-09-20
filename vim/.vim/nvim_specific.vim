let &t_ti.="\e[?7727h"
let &t_te.="\e[?7727l"
set inccommand=nosplit
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set winblend=10

let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = &lines / 2
    let width = float2nr(&columns / 2)
    let col = float2nr((&columns - width) / 2)

    let opts = {
                \ 'relative': 'editor',
                \ 'row': &lines / 4,
                \ 'col': col,
                \ 'width': width,
                \ 'height': height,
                \ 'style': 'minimal'
                \ }

    call nvim_open_win(buf, v:true, opts)
endfunction
