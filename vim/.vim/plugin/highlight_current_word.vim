augroup highlight_current_word
    au!
    au CursorMoved * call highlight_current_word#fn()
augroup END
