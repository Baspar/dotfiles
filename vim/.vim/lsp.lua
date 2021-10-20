local lspconfig = require'lspconfig'
local coq = require'coq'
local saga = require'lspsaga'

-- vim.lsp.set_log_level("debug")
-- {{{ LSP Saga
saga.init_lsp_saga {
  -- add your config value here
  -- default value
  use_saga_diagnostic_sign = true,
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
  border_style = 'round'
  -- rename_prompt_prefix = '➤',
  -- if you don't use nvim-lspconfig you must pass your server name and
  -- the related filetypes into this table
  -- like server_filetype_map = {metals = {'sbt', 'scala'}}
  -- server_filetype_map = {}
}
-- }}}

-- {{{ Coq-nvim
-- }}}

-- {{{ Nvim LSP
local configs = {}

-- {{{ HTML/CSS
configs['html'] = {}
-- }}}

-- {{{ Typescript/Javascript/ESlint
local tsFamily = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescript.tsx",
  "typescriptreact"
}
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

configs['tsserver'] = {
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
  end,
  filetypes = tsFamily,
}
configs['efm'] = {
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
configs['rls'] = {}
-- }}}

-- {{{ Scala
local scala_capabilities = vim.lsp.protocol.make_client_capabilities()
scala_capabilities.textDocument.codeAction = {
  dynamicRegistration = false;
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "",
        "quickfix",
        "refactor",
        "refactor.extract",
        "refactor.inline",
        "refactor.rewrite",
        "source",
        "source.organizeImports",
      };
    };
  };
}
configs['metals'] = {
  root_dir = lspconfig.util.find_git_ancestor;
  capabilities = scala_capabilities;
}
-- }}}

-- {{{ Python
configs['pyright'] = {}
-- }}}
--
-- {{{ C++
configs['clangd'] = {}
-- }}}

-- {{{ Go
configs['gopls'] = {}
-- }}}

--{{{ Groovy
configs['groovyls'] = {
  cmd = { "java", "-jar", "/Users/bastien/.vim/lsp-servers/groovy-language-server-all.jar" },
}
--}}}

for name, config in pairs(configs) do
  lspconfig[name].setup(coq.lsp_ensure_capabilities(config))
end
-- }}}

-- vim: foldmethod=marker:foldlevel=0
