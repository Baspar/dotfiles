highlight HighlightCurrentWord guibg=#463626 ctermbg=94
function! HighlightCurrentWordFn()
    if &filetype != "nerdtree" && &filetype != "fugitive" && &filetype != "fzf"
        try
            call matchdelete(481516)
        catch
        endtry
        let current_word = escape(expand("<cword>"), "\\/[]*")
        let b:highlight_current_word_id = matchadd("HighlightCurrentWord", "\\<" . current_word ."\\>", -1, 481516)
        "match HighlightCurrentWord /\\<" . escape(expand("<cword>"), "\\/[]") . "\\>/"
    endif
endfunction

augroup highlight_current_word
    au!
    au CursorMoved * call HighlightCurrentWordFn()
augroup END
