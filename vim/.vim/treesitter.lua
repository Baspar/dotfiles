local treesitter = require'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = "all",
  ignore_install = { "haskell" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["ic"] = "@comment.inner",
        ["ac"] = "@comment.outer",

        -- ["ac"] = "@class.outer",
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      }
    }
  }
}

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- vim: foldmethod=marker:foldlevel=1
