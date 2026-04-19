local M = {}

local fugitive_loaded = false

local function ensure_loaded()
  if fugitive_loaded then return end
  vim.pack.add({
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-rhubarb",
  })
  fugitive_loaded = true
end

M.git = function(args)
  ensure_loaded()
  vim.cmd("Git " .. (args or ""))
end

M.git_add = function()
  ensure_loaded()
  vim.cmd("Git add %:p")
end

M.gbrowse = function()
  ensure_loaded()
  vim.cmd("GBrowse")
end

M.glog = function()
  ensure_loaded()
  vim.cmd("silent! Glog")
  vim.cmd("bot copen")
end

M.gdiff = function()
  ensure_loaded()
  vim.cmd("Gdiff")
end

M.blame = function()
  ensure_loaded()
  vim.cmd("Git blame")
end

return M
