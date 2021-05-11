local lspconfig = require"lspconfig"
local compe = require"compe"
local saga = require"lspsaga"

-- vim.lsp.set_log_level("debug")
-- {{{ LSP Saga
saga.init_lsp_saga {
  -- add your config value here
  -- default value
  -- use_saga_diagnostic_sign = true
  -- error_sign = '',
  -- warn_sign = '',
  -- hint_sign = '',
  -- infor_sign = '',

  dianostic_header_icon = '',
  code_action_icon = '',
  finder_definition_icon = '',
  finder_reference_icon = '',

  code_action_prompt = {
    enable = true,
    sign = false,
    virtual_text = true,
  },
  max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
  finder_action_keys = {
    open = 'o', vsplit = 'v', split = 's',quit = { '<C-c>', 'q' },scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
  },
  code_action_keys = {
    quit = { 'q', '<C-c>' }, exec = { '<CR>', 'o' }
  },
  rename_action_keys = {
    quit = '<C-c>',exec = '<CR>'  -- quit can be a table
  },
  -- definition_preview_icon = '  '
  -- 1: thin border | 2: rounded border | 3: thick border | 4: ascii border
  border_style = 'round'
  -- rename_prompt_prefix = '➤',
  -- if you don't use nvim-lspconfig you must pass your server name and
  -- the related filetypes into this table
  -- like server_filetype_map = {metals = {'sbt', 'scala'}}
  -- server_filetype_map = {}
}
-- }}}

-- {{{ Compe
compe.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}
--- }}}

-- {{{ Nvim LSP
-- {{{ Filetypes
local tsFamily = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescript.tsx",
  "typescriptreact"
}
-- }}}

-- {{{ Typescript/Javascript
lspconfig.tsserver.setup{
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
  end,
  filetypes = tsFamily,
}
-- }}}

-- {{{ ESlint
local eslint = {
  lintCommand = "eslint_d -f compact --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {'%f: line %l, col %c, %trror - %m', '%f: line %l, col %c, %tarning - %m'},
}
local prettier = {
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true
}

lspconfig.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
  end,
  root_dir = lspconfig.util.root_pattern("yarn.lock", "lerna.json", ".git"),
  settings = {
    languages = {
      javascript = {eslint, prettier},
      javascriptreact = {eslint, prettier},
      ["javascript.jsx"] = {eslint, prettier},
      typescript = {eslint, prettier},
      ["typescript.tsx"] = {eslint, prettier},
      typescriptreact = {eslint, prettier}
    }
  },
  filetypes = tsFamily,
}
-- }}}

-- {{{ Rust
lspconfig.rls.setup{}
-- }}}

-- {{{ Scala
lspconfig.metals.setup{
  root_dir = lspconfig.util.find_git_ancestor;
}
-- }}}

-- {{{ Python
lspconfig.pyright.setup{}
-- }}}
--
-- {{{ C++
lspconfig.clangd.setup{}
-- }}}
-- }}}

-- vim: foldmethod=marker:foldlevel=0
