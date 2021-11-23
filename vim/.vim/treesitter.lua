local treesitter = require'nvim-treesitter.configs'
local indent_blankline = require'indent_blankline'

indent_blankline.setup {
  char = "┋",
  char_list = {"┋"},
  show_current_context = true,
  show_current_context_start = false,
  show_trailing_blankline_indent = false,
  use_treesitter = true,
}


treesitter.setup {
  ensure_installed = "all",
  ignore_install = { "haskell" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
}
--
-- vim: foldmethod=marker:foldlevel=1
