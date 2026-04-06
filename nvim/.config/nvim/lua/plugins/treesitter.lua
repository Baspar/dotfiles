local treesitter = require("nvim-treesitter")

treesitter.setup({})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("tree-sitter-enable", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end

    if vim.treesitter.query.get(lang, "highlights") then
      vim.treesitter.start(args.buf)
    end

    if vim.treesitter.query.get(lang, "indents") then
      vim.opt_local.indentexpr = "v:lua.vim.treesitter.indentexpr()"
    end
  end,
})

-- Treesitter node navigation
vim.keymap.set("x", "(", function()
  require("vim.treesitter._select").select_prev(vim.v.count1)
end)

vim.keymap.set("x", ")", function()
  require("vim.treesitter._select").select_next(vim.v.count1)
end)

vim.keymap.set({ "x", "o" }, "+", function()
  require("vim.treesitter._select").select_parent(vim.v.count1)
end)

vim.keymap.set({ "x", "o" }, "-", function()
  require("vim.treesitter._select").select_child(vim.v.count1)
end)
