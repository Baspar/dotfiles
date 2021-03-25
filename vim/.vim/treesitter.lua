local treesitter = require'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = "all",
  ignore_install = { "haskell" },
  highlight = {
    enable = true,
    disable = { },
  },
}
--
-- vim: foldmethod=marker:foldlevel=1
