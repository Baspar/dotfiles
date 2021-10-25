let &t_ti.="\e[?7727h"
let &t_te.="\e[?7727l"
let &t_TI = "\<Esc>[>4;2m"
let &t_TE = "\<Esc>[>4;m"
set inccommand=nosplit
set winblend=5
set pumblend=5

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { on_visual=false, higroup='HighlightCurrentWord', timeout=200 }
augroup END
