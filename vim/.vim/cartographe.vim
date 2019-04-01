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

function! s:CartographeComplete(A,L,P)
    let partial_argument = substitute(a:L, '^\S\+\s\+', '', '')
    let potential_completion = copy(keys(g:CartographeMap))
    return filter(potential_completion, {idx, val -> val =~ "^".partial_argument})
endfun

function! g:CartographeNavigate(type, command)
    if !exists("g:CartographeMap")
        echohl WarningMsg
        echom "[Cartographe] Please define your g:CartographeMap"
        echohl None
        return
    endif

    let current_file_info = s:FindType(g:CartographeMap)

    if s:Eq(current_file_info, 0)
        echohl WarningMsg
        echom "[Cartographe] Cannot match current file with any type"
        echohl None
        return
    endif

    if !has_key(g:CartographeMap, a:type)
        echohl WarningMsg
        echom "[Cartographe] Cannot find information for type '" . a:type . "'"
        echohl None
        return
    endif

    let new_path = s:InjectVariables(g:CartographeMap, a:type, current_file_info['variables'])
    let root = current_file_info['root']

    if filereadable(root.new_path)
        execute a:command root.new_path
    else
        execute a:command root.new_path
    endif
endfunction

function! g:CartographeListTypes()
    let root = '.'
    if exists("g:CartographeRoot")
        let root = g:CartographeRoot
    endif

    if !exists("g:CartographeMap")
        echohl WarningMsg
        echom "[Cartographe] Please define your g:CartographeMap"
        echohl None
        return
    endif

    let current_file_info = s:FindType(g:CartographeMap)

    if s:Eq(current_file_info, 0)
        echohl WarningMsg
        echom "[Cartographe] Cannot match current file with any type"
        echohl None
        return
    endif

    let files = split(globpath(root, '**'), '\n')

    let existing_matched_types = []
    let new_matched_types = []
    for [type, path_with_variables] in items(g:CartographeMap)
        let path = s:InjectVariables(g:CartographeMap, type, current_file_info['variables'])
        let found = 0
        for file in files
            if file =~ path.'$'
                let found = 1
                call add(existing_matched_types, "\e[0m".type)
                break
            endif
        endfor

        if !found
            call add(new_matched_types, "\e[90m".type)
        endi
    endfor

    let matches_types = existing_matched_types + new_matched_types

    function! s:handle_sink(list)
        let command = get({
                    \ 'ctrl-x': 'split',
                    \ 'ctrl-v': 'vsplit',
                    \ }, a:list[0], 'edit')
        for type in a:list[1:]
            call g:CartographeNavigate(type, command)
        endfor
    endfunction

    call fzf#run({
                \ 'source': matches_types,
                \ 'options': '--no-sort --ansi --multi --expect=ctrl-v,ctrl-x',
                \ 'down': len(matches_types)+3,
                \ 'sink*': function('s:handle_sink')
                \ })
endfunction

function! g:CartographeListComponents()
  " echo globpath(g:CartographeRoot, '**'.substitute(g:CartographeMap.index, "{[^}]*}", "*", 'g'))
  " check_variables()
  echom "ok"
endfunction

command! -nargs=0                                            CartographeList call g:CartographeListTypes()
command! -nargs=0                                            CartographeComp call g:CartographeListComponents()
command! -nargs=1 -complete=customlist,s:CartographeComplete CartographeNav  call g:CartographeNavigate('<args>', 'edit')
command! -nargs=1 -complete=customlist,s:CartographeComplete CartographeNavS call g:CartographeNavigate('<args>', 'split')
command! -nargs=1 -complete=customlist,s:CartographeComplete CartographeNavV call g:CartographeNavigate('<args>', 'vsplit')

nnoremap <leader><leader>g :CartographeList<CR>
nnoremap <leader><leader>c :CartographeComp<CR>
