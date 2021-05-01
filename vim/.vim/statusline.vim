let s:white = ['#FFFFFF', 15]
let s:orange = ['#AF875F', 3]
let s:red = ['#AF5F5E', 1]
let s:green = ['#4B8252', 2]
let s:dark_grey = ['#3A3A3A', 237]
let s:light_grey = ['#4E4E4E', 239]
let s:transparent = ['NONE', 'NONE']

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:white, s:dark_grey, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.normal.middle = [ [ s:white, s:transparent ] ]
let s:p.normal.right = [ [ s:white, s:dark_grey ], [ s:white, s:light_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.inactive.left =  [ [ s:dark_grey, s:light_grey ] ]
let s:p.inactive.middle  = [ [ s:white, s:transparent ] ]
let s:p.inactive.right = [ [ s:dark_grey, s:light_grey ] ]

let s:p.insert.left = [ [ s:white, s:orange, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.insert.right = [ [ s:white, s:dark_grey ], [ s:white, s:light_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.replace.left = [ [ s:white, s:green, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.replace.right = [ [ s:white, s:dark_grey ], [ s:white, s:light_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.visual.left = [ [ s:white, s:red, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.visual.right = [ [ s:white, s:dark_grey ], [ s:white, s:light_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.tabline.right = []
let s:p.tabline.left = [ [ s:white, s:light_grey ] ]
let s:p.tabline.tabsel = [ [ s:dark_grey, s:orange ] ]

let g:lightline#colorscheme#baspar#palette = lightline#colorscheme#flatten(s:p)

let s:mode_map = {
            \ 'n' : 'NORMAL',
            \ 'i' : 'INSERT',
            \ 'R' : 'REPLACE',
            \ 'v' : 'VISUAL',
            \ 'V' : 'V-LINE',
            \ "\<C-v>": 'V-BLOCK',
            \ 'c' : 'COMMAND',
            \ 's' : 'SELECT',
            \ 'S' : 'S-LINE',
            \ "\<C-s>": 'S-BLOCK',
            \ 't': 'TERMINAL',
            \ }

" Helper functions
func! s:is_nerd_tree(filename)
    return a:filename =~# '^NERD_tree_'
endfunc
func! s:is_fzf(filename)
    return a:filename =~# '^term://.*#FZF$'
endfunc

" Component functions
func! Coc(field)
    try
        let count = get(b:coc_diagnostic_info, a:field)
        if count == 0
            return ''
        endif
        return count
    catch /.*/
        return ''
    endtry
endfunc
func! LSPWarning()
  if has('nvim') && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let count = luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")
    if count != 0
      return count
    endif
  endif
  return ''
endfunc
func! LSPError()
  if has('nvim') && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let count = luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])")
    if count != 0
      return count
    endif
  endif
  return ''
endfunc

func! LineInfo()
    let filename = expand('%:f')
    if s:is_nerd_tree(filename)
        return ''
    elseif s:is_fzf(filename)
        return ''
    else
        return line('.') . '/' . line('$') . ':' . (col('$') - 1)
    endif
endfunc

func! FileName()
    let out = []

    let filename = expand('%:f')
    if s:is_nerd_tree(filename)
        call add(out, 'NERDTREE')
    elseif s:is_fzf(filename)
        call add(out, 'FZF')
    elseif filename == ''
        call add(out, '[No name]')
    else
        call add(out, filename)
    endif

    if &readonly
        call add(out, '')
    endif
    if &modified
        call add(out, '+')
    endif

    return join(out, '')
endfunc

func! Fugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch
    endif
    return ''
endfunc

func! Mode()
    let filename = expand('%:f')
    if s:is_nerd_tree(filename) || s:is_fzf(filename)
        return ''
    endif
    return get(s:mode_map, mode())
endfunc



let g:lightline = {
            \ 'colorscheme': 'baspar',
            \ 'tabline': {
            \   'left': [ [ 'tabs' ] ],
            \   'right': []
            \ },
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'filename' ] ],
            \   'right': [ ['fugitive'],
            \              ['lineinfo'],
            \              ['cocWarning'],
            \              ['cocError'] ]
            \ },
            \ 'inactive': {
            \   'left': [ [ 'filename', 'readOnlyModified' ] ],
            \   'right': [ ['fugitive'] ]
            \ },
            \ 'component_function': {
            \   'mode': 'Mode',
            \   'lineinfo': 'LineInfo',
            \   'fugitive': 'Fugitive',
            \   'filename': 'FileName',
            \   'cocWarning': 'LSPWarning',
            \   'cocError': 'LSPError',
            \   'readOnlyModified': 'ReadOnlyModified'
            \ },
            \ 'separator': { 'left': $LEFT_SEPARATOR, 'right': $RIGHT_SEPARATOR },
            \ 'subseparator': { 'left': $LEFT_SUB_SEPARATOR, 'right': $RIGHT_SUB_SEPARATOR }
            \ }
