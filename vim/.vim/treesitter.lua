local treesitter = require'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = "all",
  ignore_install = { "haskell" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
}

-- vim: foldmethod=marker:foldlevel=1
