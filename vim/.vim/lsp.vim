" {{{ Typescript/Javascript
" {{{ [x] ESLint Language Server
if filereadable(glob('~/.vim/lsp-servers/eslint-language-server/eslint-language-server'))
  au User lsp_setup call lsp#register_server({
        \ 'name': 'eslint-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/eslint-language-server/eslint-language-server --stdio']},
        \ 'whitelist': ['javascriptreact', 'javascript', 'javascript.jsx', 'typescriptreact', 'typescript', 'typescript.jsx'],
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
        \ 'whitelist': ['javascriptreact', 'javascript', 'javascript.jsx', 'typescriptreact', 'typescript', 'typescript.jsx']
        \ })
endif
" }}}
" {{{ [ ] Javascript Typescript STDIO
" if filereadable(glob('~/.vim/lsp-servers/javascript-typescript-langserver/lib/language-server-stdio.js'))
"     au User lsp_setup call lsp#register_server({
"     \ 'name': 'javascript-typescript-stdio',
"     \ 'cmd': {server_info->[&shell, &shellcmdflag, 'node', '~/.vim/lsp-servers/javascript-typescript-langserver/lib/language-server-stdio.js']},
"     \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
"     \ 'workspace_config': {},
"     \ 'whitelist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.jsx'],
"     \ })
" endif
" }}}
" }}}

" {{{ Rust
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
" }}}

" {{{ Clojure
" {{{ [x] Kondo LSP
if filereadable(glob('~/.vim/lsp-servers/kondo-lsp.jar'))
  au User lsp_setup call lsp#register_server({
    \   'name': 'kondo-lsp',
    \   'cmd': {server_info->[&shell, &shellcmdflag, 'java -jar ~/.vim/lsp-servers/kondo-lsp.jar']},
    \   'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'project.clj'))},
    \   'whitelist': ['clojure'],
    \ })
endif
" }}}
" {{{ [x] Clojure LSP
if filereadable(glob('~/.vim/lsp-servers/clojure-lsp'))
  au User lsp_setup call lsp#register_server({
        \   'name': 'clojure-lsp',
        \   'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/clojure-lsp']},
        \   'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'deps.edn'))},
        \   'config': { 'diagnostics': 'false' },
        \   'whitelist': ['clojure'],
        \ })
endif
" }}}
" }}}

" {{{ Scala
" {{{ [x] Metals
if filereadable(glob('~/.vim/lsp-servers/metals'))
  au User lsp_setup call lsp#register_server({
        \   'name': 'metals',
        \   'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/metals']},
        \   'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'deps.edn'))},
        \   'initialization_options': {'isHttpEnabled': 'true'},
        \   'whitelist': ['scala', 'sbt'],
        \ })
endif
" }}}
" }}}
" vim: foldmethod=marker:foldlevel=1
