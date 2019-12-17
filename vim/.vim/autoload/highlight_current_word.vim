function! highlight_current_word#fn()
  let exclude_ft = ["nerdtree", "fugitive", "fzf"]
    if index(exclude_ft, &filetype) == -1
        try
            call matchdelete(481516)
        catch
        endtry
        let current_word = escape(expand("<cword>"), "\\/[]*~")
        call matchadd("HighlightCurrentWord", "\\<" . current_word ."\\>", 0, 481516)
    endif
endfunction
