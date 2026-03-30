augroup highlight_current_word
    au!
    " hi! HighlightCurrentWord ctermbg=94
    hi! HighlightCurrentWord guibg=#ebdab4 ctermbg=94
    " hi! link HighlightCurrentWord Folded

    au CursorMoved * call highlight_current_word#fn()
augroup END
