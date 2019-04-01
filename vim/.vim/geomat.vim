function! s:Eq(a, b)
    return type(a:a) == type(a:b) && a:a == a:b
endfunction

function! s:SanitizePath(path)
    return substitute(a:path."$", "{[^}]*}", '\\([^/]*\\)', 'g')
endfunction

function! s:ExtractVariables(settings, type, file_path)
    let path = a:settings[a:type]
    let sanitized_path = s:SanitizePath(path)
    let match = matchlist(a:file_path, sanitized_path)
    if len(match) > 0
        let match_variables = {}
        let variable_names = []
        let root = matchlist(a:file_path, '^\(.*/\)'.sanitized_path)[1]
        call substitute(path, '{\zs[a-zA-Z]*\ze}', '\=add(variable_names, submatch(0))', 'g')
        let no_error = 1
        for id in range(len(variable_names))
            let variable_name = variable_names[id]
            let variable_value = match[id+1]
            if has_key(match_variables, variable_name) && match_variables[variable_name] != variable_value
                let no_error = 0
            endif
            let match_variables[variable_name] = variable_value
        endfor

        if no_error == 1
            return { 'variables': match_variables, 'root': root }
        endif
    endif
endfunction

function! s:InjectVariables(settings, type, variables)
    let path_with_variables = a:settings[a:type]
    for [var_name, var_value] in items(a:variables)
        let path_with_variables = substitute(path_with_variables, '{'.var_name.'}', var_value, 'g')
    endfor
    return path_with_variables
endfunction!

function! s:FindType(settings)
    let pairs = items(a:settings)
    let file_path = expand("%:p")

    for type in keys(a:settings)
        let file_info = s:ExtractVariables(a:settings, type, file_path)
        if !s:Eq(file_info, 0)
            let file_info['type'] = type
            return file_info
        endif
    endfor
endfunction

function! s:GeomatNavigate(type, command)
    if !exists("g:GeomatMap")
        echohl WarningMsg
        echom "[Geomat] Please define your g:GeomatMap"
        echohl None
        return
    endif

    let current_file_info = s:FindType(g:GeomatMap)

    if s:Eq(current_file_info, 0)
        echohl WarningMsg
        echom "[Geomat] Cannot match current file with any type"
        echohl None
        return
    endif

    if !has_key(g:GeomatMap, a:type)
        echohl WarningMsg
        echom "[Geomat] Cannot find information for type '" . a:type . "'"
        echohl None
        return
    endif

    let new_path = s:InjectVariables(g:GeomatMap, a:type, current_file_info['variables'])
    let root = current_file_info['root']

    if filereadable(root.new_path)
        execute a:command root.new_path
    else
        execute a:command root.new_path
    endif
endfunction

function! s:GeomatComplete(A,L,P)
    let partial_argument = substitute(a:L, '^\S\+\s\+', '', '')
    let potential_completion = copy(keys(g:GeomatMap))
    return filter(potential_completion, {idx, val -> val =~ "^".partial_argument})
endfun

function! g:GeomatList()
    let root = '.'
    if exists("g:GeomatRoot")
        let root = g:GeomatRoot
    endif

    if !exists("g:GeomatMap")
        echohl WarningMsg
        echom "[Geomat] Please define your g:GeomatMap"
        echohl None
        return
    endif

    let current_file_info = s:FindType(g:GeomatMap)

    if s:Eq(current_file_info, 0)
        echohl WarningMsg
        echom "[Geomat] Cannot match current file with any type"
        echohl None
        return
    endif

    let files = split(globpath(root, '**'), '\n')

    let matches_types = []
    for [type, path_with_variables] in items(g:GeomatMap)
        let path = s:InjectVariables(g:GeomatMap, type, current_file_info['variables'])
        for file in files
            if file =~ path.'$'
                call add(matches_types, type)
            endif
        endfor
    endfor

    function! s:handle_sink(list)
        let command = get({
                    \ 'ctrl-x': 'split',
                    \ 'ctrl-v': 'vsplit',
                    \ }, a:list[0], 'e')
        for type in a:list[1:]
            call s:GeomatNavigate(type, command)
        endfor
    endfunction

    call fzf#run({
                \ 'source': matches_types,
                \ 'options': '--multi --expect=ctrl-v,ctrl-x',
                \ 'down': '20%',
                \ 'sink*': function('s:handle_sink')
                \ })
endfunction


command! -nargs=1 -complete=customlist,s:GeomatComplete GNav  call s:GeomatNavigate('<args>', 'edit')
command! -nargs=1 -complete=customlist,s:GeomatComplete GNavS call s:GeomatNavigate('<args>', 'split')
command! -nargs=1 -complete=customlist,s:GeomatComplete GNavV call s:GeomatNavigate('<args>', 'vsplit')

nnoremap <leader><leader>g :call g:GeomatList()<CR>
