let s:white = ['', 15]
let s:orange = ['', 3]
let s:red = ['', 1]
let s:green = ['', 2]
let s:dark_grey = ['', 237]
let s:light_grey = ['', 239]
let s:transparent = ['', 'NONE']

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:white, s:dark_grey, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.normal.middle = [ [ s:white, s:transparent ] ]
let s:p.normal.right = [ [ s:white, s:orange ], [ s:white, s:dark_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.inactive.left =  [ [ s:dark_grey, s:light_grey ] ]
let s:p.inactive.middle  = [ [ s:white, s:transparent ] ]
let s:p.inactive.right = [ [ s:white, s:dark_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.insert.left = [ [ s:white, s:orange, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.insert.right = [ [ s:white, s:orange ], [ s:white, s:dark_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.replace.left = [ [ s:white, s:green, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.replace.right = [ [ s:white, s:orange ], [ s:white, s:dark_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

let s:p.visual.left = [ [ s:white, s:red, 'bold' ], [ s:white, s:light_grey ] ]
let s:p.visual.right = [ [ s:white, s:orange ], [ s:white, s:dark_grey ], [ s:white, s:orange ], [ s:white, s:red ] ]

" let s:p.normal.error = [ [ s:base2, s:red ] ]
" let s:p.normal.warning = [ [ s:base02, s:yellow ] ]

let g:lightline#colorscheme#baspar#palette = lightline#colorscheme#flatten(s:p)
" b:coc_diagnostic_info

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
func! CocWarning()
    return Coc('warning')
endfunc
func! CocError()
    return Coc('error')
endfunc

func! LineInfo()
    return (col('.') - 1) . '/' . (col('$') - 1)
endfunc

func! FileName()
    let out = [expand('%f')]
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
        return ' '.branch
    endif
    return ''
endfunc



let g:lightline = {
            \ 'colorscheme': 'baspar',
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
            \   'right': []
            \ },
            \ 'component_function': {
            \   'fugitive': 'Fugitive',
            \   'filename': 'FileName',
            \   'cocWarning': 'CocWarning',
            \   'cocError': 'CocError',
            \   'readOnlyModified': 'ReadOnlyModified'
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' }
            \ }
