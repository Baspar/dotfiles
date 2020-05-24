" {{{ LSP servers config
    " {{{ ESLint Language Server
    if filereadable(glob('~/.vim/lsp-servers/eslint-language-server/eslint-language-server'))
        au User lsp_setup call lsp#register_server({
        \ 'name': 'eslint-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/eslint-language-server/eslint-language-server --stdio']},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ 'initialization_options': { 'diagnostic': 'true' },
        \ 'workspace_config': {
        \   'validate': 'probe',
        \   'packageManager': 'npm',
        \   'codeActionOnSave': {
        \     'enable': v:true,
        \     'mode': 'all',
        \   },
        \   'codeAction': {
        \     'disableRuleComment': {
        \       'enable': v:true,
        \       'location': 'separateLine',
        \     },
        \     'showDocumentation': {
        \       'enable': v:true,
        \     },
        \   },
        \   'format': v:false,
        \   'quiet': v:false,
        \   'onIgnoredFiles': 'off',
        \   'options': {},
        \   'run': 'onType',
        \   'nodePath': v:null,
        \ },
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ })
    endif
    " }}}
    " {{{ TypeScript Language Server
    if executable('typescript-language-server')
        au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
    endif
    " }}}
    " {{{ Javascript Typescript STDIO
    " if executable('javascript-typescript-stdio')
    "     au User lsp_setup call lsp#register_server({
    "     \ 'name': 'javascript-typescript-stdio',
    "     \ 'cmd': {server_info->[&shell, &shellcmdflag, 'javascript-typescript-stdio']},
    "     \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
    "     \ 'workspace_config': {},
    "     \ 'whitelist': ['javascript', 'javascript.jsx'],
    "     \ })
    " endif
    " }}}
    " {{{ Rust Analyzer
    if executable('cargo')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'rls',
            \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
            \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
            \ 'whitelist': ['rust'],
            \ })
    endif
    " }}}
" }}}

" {{{ Config
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_virtual_text_enabled = 0
" }}}

" {{{ Highlight
hi LspInformationText ctermfg=239 ctermbg=3
hi LspHintText ctermfg=239 ctermbg=3
" }}}

" vim: foldmethod=marker:foldlevel=1
