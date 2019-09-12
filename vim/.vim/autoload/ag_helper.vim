function! ag_helper#look_for_block(start, end)
    let old_buffer = @"
    execute 'normal! ' . a:start .'v' . a:end . 'y:Ag'
    execute 'Ag ' . @"
    let @" = old_buffer
endfunction
function! ag_helper#look_for_block_op(type)
    call ag_helper#look_for_block('`[', '`]')
endfunction
