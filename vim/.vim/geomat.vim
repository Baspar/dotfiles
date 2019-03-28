function! s:Eq(a, b)
    return type(a:a) == type(a:b) && a:a == a:b
endfunction

function! s:SanitizePath(path)
    return substitute(a:path."$", "{[^}]*}", '\\([^/]*\\)', 'g')
endfunction

function! s:FindType(settings)
    let pairs = items(a:settings)
    let current_file = expand("%:p")
    for [type, path] in pairs
        let sanitized_path = s:SanitizePath(path)
        let match = matchlist(current_file, sanitized_path)
        if len(match) > 0
            let match_variables = {}
            let variable_names = []
            let root = matchlist(current_file, '^\(.*/\)'.sanitized_path)[1]
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
                return { 'type': type, 'current_file': current_file, 'variables': match_variables, 'root': root }
            endif
        endif
    endfor
endfunction

function! GeomatNavigate(type, command)
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

    let path_with_variables = g:GeomatMap[a:type]
    let root = current_file_info['root']
    for [var_name, var_value] in items(current_file_info['variables'])
        let path_with_variables = substitute(path_with_variables, '{'.var_name.'}', var_value, 'g')
    endfor
    echom a:command
    if filereadable(root.path_with_variables)
        execute a:command root.path_with_variables
    else
        execute a:command root.path_with_variables
    endif
endfunction

function! s:GeomatComplete(A,L,P)
    let partial_argument = substitute(a:L, '^\S\+\s\+', '', '')
    let potential_completion = copy(keys(g:GeomatMap))
    return filter(potential_completion, {idx, val -> val =~ "^".partial_argument})
endfun


command! -nargs=1 -complete=customlist,s:GeomatComplete GNav call GeomatNavigate('<args>', 'edit')
command! -nargs=1 -complete=customlist,s:GeomatComplete GNavS call GeomatNavigate('<args>', 'split')
command! -nargs=1 -complete=customlist,s:GeomatComplete GNavV call GeomatNavigate('<args>', 'vsplit')
