" {{{ LSP servers config
    " {{{ Javascript
    if executable('typescript-language-server')
          au User lsp_setup call lsp#register_server({
        \ 'name': 'javascript support using typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
    endif
    " }}}
    " {{{ Javascript
    if executable('rls')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'rls',
            \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
            \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
            \ 'whitelist': ['rust'],
            \ })
    endif
    " }}}
    " {{{ Scala
    if executable('metals-vim')
       au User lsp_setup call lsp#register_server({
          \ 'name': 'metals',
          \ 'cmd': {server_info->['metals-vim']},
          \ 'initialization_options': { 'rootPatterns': 'build.sbt' },
          \ 'whitelist': [ 'scala', 'sbt' ],
          \ })
    endif
    " }}}
" }}}

" {{{ Config
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_enabled = 0
let g:ale_virtualtext_cursor = 1
" }}}

" {{{ Highlight
hi LspInformationText ctermfg=239 ctermbg=3 guifg=guibg=
hi LspHintText ctermfg=239 ctermbg=3 guifg=guibg=
" }}}

" vim: foldmethod=marker:foldlevel=1
