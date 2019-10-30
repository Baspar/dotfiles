highlight HighlightCurrentWord guibg=#463626 ctermbg=94

augroup highlight_current_word
    au!
    au CursorMoved * call highlight_current_word#fn()
augroup END
