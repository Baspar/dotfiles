vim.opt.wrap = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.emoji = false
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.encoding = "utf8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.hidden = true
vim.opt.foldmethod = "indent"
vim.opt.wildmenu = true
vim.opt.spelllang = "en"
vim.opt.spellfile = vim.fn.expand("$HOME/.config/nvim/spell/en.utf-8.add")
vim.opt.undodir = vim.fn.expand("$HOME/.config/nvim/undo//")
vim.opt.directory = vim.fn.expand("$HOME/.config/nvim/swap//")
vim.opt.shell = "/bin/bash"
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.listchars = { tab = "┋ ", trail = "■", eol = "↩" }
vim.opt.laststatus = 2
vim.opt.synmaxcol = 300
vim.opt.termguicolors = true
vim.opt.fillchars = { stl = "━", stlnc = "╍" }
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "git" },
  callback = function()
    vim.opt_local.foldmethod = "syntax"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "netrw" },
  callback = function()
    vim.cmd("vertical resize 30")
  end,
})

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.ftplugin_sql_omni_key = "<C-s>"
