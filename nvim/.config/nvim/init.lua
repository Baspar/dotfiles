vim.g.mapleader = ","
vim.g.maplocalleader = " "

require("config.options")
require("config.plugins")
require("config.mappings")
require("config.statusline")
require("config.colors")

require("utils.highlight_current_word")

require("plugins.lsp")
require("plugins.treesitter")
require("plugins.fzf")
require("plugins.indent")
require("plugins.leap")
require("plugins.misc")

vim.opt.exrc = true
local git_vimrc = vim.fn.getcwd() .. "/.git/vimrc"
if vim.fn.filereadable(git_vimrc) == 1 then
  vim.cmd.source(git_vimrc)
end
