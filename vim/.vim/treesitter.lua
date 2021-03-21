local treesitter = require'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,
    disable = { },  -- list of language that will be disabled
  },
}
--
-- vim: foldmethod=marker:foldlevel=1
