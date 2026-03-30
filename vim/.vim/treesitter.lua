local treesitter = require'nvim-treesitter'

treesitter.setup {}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("tree-sitter-enable", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end
    if vim.treesitter.query.get(lang, "highlights") then vim.treesitter.start(args.buf) end
  end,
})
--   ensure_installed = "all",
--   ignore_install = { "haskell", "ipkg" },
--
--   highlight = {
--     enable = true,
--     additional_vim_regex_highlighting = true
--   },
--
--   -- textobjects = {
--   --   select = {
--   --     enable = true,
--   --     lookahead = true,
--   --     keymaps = {
--   --       ["af"] = "@function.outer",
--   --       ["if"] = "@function.inner",
--   --
--   --       ["ic"] = "@comment.inner",
--   --       ["ac"] = "@comment.outer",
--   --
--   --       -- ["ac"] = "@class.outer",
--   --       ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
--   --     }
--   --   }
--   -- }
-- }

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- vim: foldmethod=marker:foldlevel=1
