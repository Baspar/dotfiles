local map = vim.keymap.set

-- Keep visual selection
map("v", "<", "<gv")
map("v", ">", ">gv")

-- */#/n/N
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

-- Change j/k to wrap correctly
map("n", "j", "gj")
map("n", "k", "gk")

-- cgn/cgN
map("n", "c*", "*``cgn")
map("n", "c#", "#``cgN")
map("n", "c>*", "*``cgn<C-r><C-o>\"")
map("n", "c>#", "#``cgN<C-r><C-o>\"")

-- FZF
map("n", "\\", ":FzfLua buffers<CR>", { silent = true })
map("n", "<tab>", ":FzfLua git_files<CR>", { silent = true })
map("n", "<s-tab>", ":FzfLua files<CR>", { silent = true })

-- File explorer
map("n", "<C-e>", function()
  vim.cmd("NERDTreeToggle")
  vim.cmd("doautocmd User NerdTreeOpen")
end, { silent = true })
map("n", "-", function()
  vim.cmd("NERDTreeFind")
  vim.cmd("doautocmd User NerdTreeOpen")
end, { silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nerdtree",
  callback = function()
    vim.keymap.del("n", "q", { buffer = true })
  end,
})

-- Undo Tree
map("n", "<C-u>", ":UndotreeToggle<CR>")
map("n", "<leader>u", ":UndotreeToggle<CR>")

-- Disable arrow keys in insert
map("i", "<up>", "<nop>")
map("i", "<down>", "<nop>")
map("i", "<left>", "<nop>")
map("i", "<right>", "<nop>")

-- Navigate split
map("n", "<up>", "<C-w><up>")
map("n", "<down>", "<C-w><down>")
map("n", "<left>", "<C-w><left>")
map("n", "<right>", "<C-w><right>")

-- Clipboard usage
map("n", "<leader>cy", "\"+y")
map("n", "<leader>cP", "\"+P")
map("n", "<leader>cp", "\"+p")
map("n", "<leader>cd", "\"+d")
map("v", "<leader>cy", "\"+y")
map("v", "<leader>cP", "\"+P")
map("v", "<leader>cp", "\"+p")
map("v", "<leader>cd", "\"+d")

-- Buffer navigation
map("n", "<leader><", ":tabN<CR>")
map("n", "<leader>>", ":tabn<CR>")
map("n", "<leader><CR>", "m0:tabe %<CR>`0")
map("n", "<leader>bd", ":bn<CR>:bd #<CR>")

-- Save and exit
map("n", "<leader>s", ":noh<CR>:update<CR>")
map("n", "<leader>w", ":noh<CR>:w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>Q", ":q!<CR>")

-- Clear highlight
map("n", "<C-l>", ":noh<CR>")

-- Reload nvim config
map("n", "<leader>vr", ":source $MYVIMRC<CR>")
map("n", "<leader>vE", ":tabe $MYVIMRC<CR>")
map("n", "<leader>ve", ":e $MYVIMRC<CR>")
map("n", "<leader>vL", ":tabe ~/.config/nvim/lua/config/lsp.lua<CR>")
map("n", "<leader>vl", ":e ~/.config/nvim/lua/config/lsp.lua<CR>")
map("n", "<leader>vM", ":tabe ~/.config/nvim/lua/config/mappings.lua<CR>")
map("n", "<leader>vm", ":e ~/.config/nvim/lua/config/mappings.lua<CR>")
map("n", "<leader>vP", ":tabe ~/.config/nvim/lua/config/plugins.lua<CR>")
map("n", "<leader>vp", ":e ~/.config/nvim/lua/config/plugins.lua<CR>")
map("n", "<leader>vC", ":tabe ~/.config/nvim/lua/config/colors.lua<CR>")
map("n", "<leader>vc", ":e ~/.config/nvim/lua/config/colors.lua<CR>")
map("n", "<leader>vT", ":tabe ~/.config/nvim/lua/config/treesitter.lua<CR>")
map("n", "<leader>vt", ":e ~/.config/nvim/lua/config/treesitter.lua<CR>")
map("n", "<leader>vS", ":tabe ~/.config/nvim/lua/config/statusline.lua<CR>")
map("n", "<leader>vs", ":e ~/.config/nvim/lua/config/statusline.lua<CR>")
map("n", "<leader>vV", ":tabe ~/.config/nvim/init.lua<CR>")
map("n", "<leader>vv", ":e ~/.config/nvim/init.lua<CR>")

-- Splits
map("n", "<leader>|", ":vs<CR>")
map("n", "<leader>_", ":sp<CR>")
map("n", "<leader>-", ":sp<CR>")
map("n", "<C-w><C-w>", "<C-w>|<C-w>_")

-- Fugitive
local function toggle_git_status()
  if vim.fn.buflisted(".git/index") == 1 then
    vim.cmd("bd .git/index")
  else
    vim.cmd("Git")
  end
end

map("n", "<leader>ga", ":Git add %:p<CR><CR>")
map("n", "<leader>go", ":GBrowse<CR>")
map("v", "<leader>go", ":GBrowse<CR>")
map("n", "<leader>gs", toggle_git_status)
map("n", "<leader>gl", ":silent! Glog<CR>:bot copen<CR>")
map("n", "<leader>gd", ":Gdiff<CR>")
map("n", "<leader>gb", ":Git blame<CR>")

-- Select all
map("n", "<leader>a", "ggVG")

-- Rgs
map("n", "<leader>F", ":FzfLua grep<CR>")
map("n", "<leader>f", function()
  vim.opt.operatorfunc = "v:lua.require'utils.ag_helper'.look_for_block_op"
  return "g@"
end, { expr = true })
map("n", "<leader>f<leader>f", "<leader>fiw", { remap = true })
map("v", "<leader>f", ":<C-u>lua require'utils.ag_helper'.look_for_block()<CR>")

-- Duplicates
map("n", "<leader>d", function()
  vim.opt.operatorfunc = "v:lua.require'utils.duplicate'.duplicate_op"
  return "g@"
end, { expr = true })
map("n", "<leader>d<leader>d", "yyP")
map("v", "<leader>d", ":<C-u>lua require'utils.duplicate'.duplicate()<CR>")

-- Repl-it
map("n", "<leader>r", function()
  return require("utils.repl_it").normal_mode()
end, { expr = true })
map("v", "<leader>r", ":<C-u>lua require'utils.repl_it'.visual_mode()<CR>")
map("n", "<leader>rr", "V<leader>r", { remap = true })

-- LSP
map("n", "K", vim.lsp.buf.hover, { silent = true })
map("n", "]a", function()
  vim.diagnostic.jump({ count = 1, float = { max_width = 150, focusable = false, border = "rounded" } })
end, { silent = true })
map("n", "[a", function()
  vim.diagnostic.jump({ count = -1, float = { max_width = 150, focusable = false, border = "rounded" } })
end, { silent = true })
map("n", "<localleader>r", ":FzfLua lsp_references<CR>", { silent = true })
map("n", "<localleader>d", ":FzfLua lsp_definitions<CR>", { silent = true })
map("n", "<localleader>i", ":FzfLua lsp_implementations<CR>", { silent = true })
map("n", "<localleader>D", "m0:tabe %<CR>`0:lua vim.lsp.buf.definition()<CR>", { silent = true })
map("n", "<localleader>f", vim.lsp.buf.format, { silent = true })
map("v", "<localleader>f", vim.lsp.buf.format, { silent = true })
map("n", "<localleader>R", vim.lsp.buf.rename, { silent = true })
map("n", "<localleader><localleader>", ":FzfLua lsp_code_actions<CR>", { silent = true })
map("v", "<localleader><localleader>", ":'<,'>FzfLua lsp_code_actions<CR>", { silent = true })

-- Markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    map("n", "<localleader>n", ":normal o- [-]<CR>hr jk", { buffer = true })
    map("n", "<localleader><localleader>", ":s/^\\([^a-zA-Z0-9]*\\)\\[.\\?\\]/\\1\\[x\\]<CR>:noh<CR>j", { buffer = true })
    map("v", "<localleader><localleader>", ":'<,'>s/^\\([^a-zA-Z0-9]*\\)\\[.\\?\\]/\\1\\[x\\]<CR>:noh<CR>", { buffer = true })
    map("n", "<localleader><backspace>", ":s/^\\([^a-zA-Z0-9]*\\)\\[.\\?\\]/\\1\\[ \\]<CR>:noh<CR>j", { buffer = true })
    map("v", "<localleader><backspace>", ":'<,'>s/^\\([^a-zA-Z0-9]*\\)\\[.\\?\\]/\\1\\[ \\]<CR>:noh<CR>", { buffer = true })
    map("n", "<localleader>w", ":s/^\\([^a-zA-Z0-9]*\\)\\[.\\?\\]/\\1\\[-\\]<CR>:noh<CR>j", { buffer = true })
    map("v", "<localleader>w", ":'<,'>s/^\\([^a-zA-Z0-9]*\\)\\[.\\?\\]/\\1\\[-\\]<CR>:noh<CR>", { buffer = true })
  end,
})

-- Netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    map("n", "o", "<CR>", { buffer = true })
  end,
})

-- Move lines
map("n", "<S-down>", "ddp")
map("v", "<S-down>", "dpV`]")
map("n", "<S-up>", "ddkP")
map("v", "<S-up>", "dkPV`]")

-- Vsnip
map({ "i", "s" }, "<C-l>", function()
  if vim.fn["vsnip#available"](1) == 1 then
    return "<Plug>(vsnip-expand-or-jump)"
  else
    return "<C-l>"
  end
end, { expr = true })

-- Emacs Ctrl-a
map("c", "<C-A>", "<Home>")
