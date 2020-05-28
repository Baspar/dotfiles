" {{{ LSP servers config
    " {{{ [x] ESLint Language Server
    if filereadable(glob('~/.vim/lsp-servers/eslint-language-server/eslint-language-server'))
        au User lsp_setup call lsp#register_server({
        \ 'name': 'eslint-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/eslint-language-server/eslint-language-server --stdio']},
        \ 'whitelist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.jsx'],
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
    " {{{ [x] TypeScript Language Server
    if executable('typescript-language-server')
        au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.jsx'],
        \ })
    endif
    " }}}
    " {{{ [ ] Javascript Typescript STDIO
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
    " {{{ [x] Rust Analyzer
    if executable('cargo')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'rls',
            \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
            \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
            \ 'whitelist': ['rust'],
            \ })
    endif
    " }}}
    " {{{ [x] Kondo LSP
    " if filereadable(glob('~/.vim/lsp-servers/kondo-lsp.jar'))
    "   au User lsp_setup call lsp#register_server({
    "     \   'name': 'kondo-lsp',
    "     \   'cmd': {server_info->[&shell, &shellcmdflag, 'java -jar ~/.vim/lsp-servers/kondo-lsp.jar']},
    "     \   'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'project.clj'))},
    "     \   'config': { 'diagnostics': 'true' },
    "     \   'whitelist': ['clojure'],
    "     \ })
    " endif
    " }}}
    " {{{ [x] Clojure LSP
    if filereadable(glob('~/.vim/lsp-servers/clojure-lsp'))
      au User lsp_setup call lsp#register_server({
        \   'name': 'clojure-lsp',
        \   'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/clojure-lsp']},
        \   'root_uri': {server_info-> 'file:///Users/baspar/xxx/'},
        \   'initialization_options': {'macro-defs': {'cljs.core/..': ['elements']}},
        \   'whitelist': ['clojure'],
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
