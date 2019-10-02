highlight HighlightCurrentWord guibg=#463626 ctermbg=94
function! HighlightCurrentWordFn()
    if &filetype != "nerdtree" && &filetype != "fugitive" && &filetype != "fzf"
        try
            call matchdelete(4345)
        catch
        endtry
        let b:highlight_current_word_id = matchadd("HighlightCurrentWord", "\\<" . escape(expand("<cword>"), "\\/[]") ."\\>", -1, 4345)
        "match HighlightCurrentWord /\\<" . escape(expand("<cword>"), "\\/[]") . "\\>/"
    endif
endfunction

augroup highlight_current_word
    au!
    au CursorMoved * call HighlightCurrentWordFn()
augroup END
