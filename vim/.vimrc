function! s:load_files (path)
  let vim_file = expand("~/.vim/" . a:path . ".vim")
  let lua_file = expand("~/.vim/" . a:path . ".lua")

  if filereadable(vim_file)
    execute 'source' vim_file
  endif

  if has("nvim") && filereadable(lua_file)
    execute 'luafile' lua_file
  endif
endfunction

call s:load_files("plugins")
call s:load_files("config")
call s:load_files("mappings")
call s:load_files("statusline")

call s:load_files("lsp")
call s:load_files("treesitter")

if has("nvim")
  call s:load_files("nvim_specific")
else
  call s:load_files("vim_specific")
endif

set exrc
if filereadable(getcwd()."/.git/vimrc")
    execute "source" getcwd()."/.git/vimrc"
endif
