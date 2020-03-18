function! duplicate#duplicate(start, end)
    let old_buffer = @"
    execute 'normal! ' . a:start .'v' . a:end . 'yP'
    let @" = old_buffer
endfunction
function! duplicate#duplicate_op(type)
    call duplicate#duplicate('`[', '`]')
endfunction
