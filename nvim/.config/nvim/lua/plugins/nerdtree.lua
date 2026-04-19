local nerdtree_loaded = false

local load_nerdtree = function(operation)
  if not nerdtree_loaded then
    vim.pack.add({ "https://github.com/scrooloose/nerdtree" })
    vim.g.NERDTreeMinimalUI = 1
    vim.g.NERDTreeDirArrows = 1
    vim.g.NERDTreeQuitOnOpen = 1

    nerdtree_loaded = true
  end

  if operation == "toggle" then
    vim.cmd("NERDTreeToggle")
  elseif operation == "find" then
    vim.cmd("NERDTreeFind")
  else
    return
  end

  vim.cmd("doautocmd User NerdTreeOpen")
end

return {
  toggle = function() return load_nerdtree("toggle") end,
  find = function() return load_nerdtree("find") end,
}
