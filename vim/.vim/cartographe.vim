" Helpers
function! s:Eq(a, b)
    return type(a:a) == type(a:b) && a:a == a:b
endfunction

" Error Handling
function! s:Error(err)
    return { 'Error': a:err }
endfunction

function! s:HasError(res)
    return type(a:res) == type({}) && has_key(a:res, 'Error')
endfunction

" Modifiers handling
function! s:FormatWithModifiers(name, modifiers)
    return a:name
endfunction

function! s:UnformatWithModifiers(name, modifiers)
    return a:name
endfunction

" Variables manipulation
function! s:CheckVariables(variables)
    let info = a:variables.info
    let values = a:variables.values

    " Cannot match pattern
    if len(values) == 0
        return s:Error('Cannot match')
    endif

    " Cannot match all variables
    for i in range(len(info))
        if s:Eq(values[i], '')
            return s:Error('Cannot match')
        endif
    endfor

    let mem_variables = {}
    for id in range(len(info))
        let variable_name = info[id].name
        let variable_modifiers = info[id].modifiers
        let has_modifier = len(variable_modifiers) > 0
        let variable_value = values[id]

        " Variable already seen
        if has_key(mem_variables, variable_name)
            " All or none should have a modifier
            if mem_variables[variable_name].has_modifier != has_modifier
                return s:Error('Cannot match')
            endif

            " Value doesn't match
            if mem_variables[variable_name].value != s:FormatWithModifiers(variable_value, variable_modifiers)
                return s:Error('Cannot match')
            endif
        endif
        let mem_variables[variable_name] = {
                    \ 'value': s:FormatWithModifiers(variable_value, variable_modifiers),
                    \ 'has_modifier': len(variable_modifiers) > 0
                    \ }
    endfor

    return mem_variables
endfunction

function! s:ExtractVariables(pattern, file_path)
    let variables_values = matchlist(a:file_path, substitute(a:pattern."$", "{[^}]*}", "\\\\([^/]*\\\\)", "g"))[1:]
    let variables_info = []
    call substitute(a:pattern, '{\zs[a-zA-Z]*\%(:[a-zA-Z]\+\)*\ze}', '\=add(variables_info, submatch(0))', 'g')
    let variables_info = map(variables_info, {id, name -> {
                \ 'name': split(name, ':')[0],
                \ 'modifiers': split(name, ':')[1:]
                \ }})

    return {
                \ 'info': variables_info,
                \ 'values': variables_values
                \ }
endfunction

function! s:InjectVariables(pattern, variables)
    let potential_path = a:pattern
    for [var_name, var_info] in items(a:variables)
        let var_value = var_info['value']
        let potential_path = substitute(potential_path, '{'.var_name.'}', var_value, 'g')
    endfor
    return potential_path
endfunction!

function! s:ExtractRoot(file_path, root, pattern)
    let sanitized_path = substitute(a:pattern."$", "{[^}]*}", "\\\\([^/]*\\\\)", "g")
    return matchlist(a:file_path, '^\(.*\)'.sanitized_path)[1]
endfunction

function! s:FindType(settings, root)
    let pairs = items(a:settings)
    let file_path = expand("%:p")

    for type in keys(a:settings)
        let pattern = a:settings[type]
        let variables_info = s:ExtractVariables(pattern, file_path)
        let checked_variables = s:CheckVariables(variables_info)
        if !s:HasError(checked_variables)
            let checked_variables['type'] = type
            let root = s:ExtractRoot(file_path, a:root, pattern)
            return {
                        \ 'variables': checked_variables,
                        \ 'type': type,
                        \ 'root': root
                        \ }
        endif
    endfor

    return s:Error('Cannot find a type')
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

    let current_file_info = s:FindType(g:CartographeMap, g:CartographeRoot)

    if s:HasError(current_file_info)
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

    let new_path = s:InjectVariables(g:CartographeMap[a:type], current_file_info['variables'])
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

    let current_file_info = s:FindType(g:CartographeMap, g:CartographeRoot)

    if s:HasError(current_file_info)
        echohl WarningMsg
        echom "[Cartographe] Cannot match current file with any type"
        echohl None
        return
    endif

    " echo current_file_info
    " return

    " let files = split(globpath(root, '**'), '\n')
    echo

    let existing_matched_types = []
    let new_matched_types = []
    for [type, path_with_variables] in items(g:CartographeMap)
        let path = s:InjectVariables(g:CartographeMap[type], current_file_info['variables'])
        if filereadable(current_file_info['root'].path)
            call add(existing_matched_types, "\e[0m".type)
        else
            call add(new_matched_types, "\e[90m".type)
        endif
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
