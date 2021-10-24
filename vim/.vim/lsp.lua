local lspconfig = require'lspconfig'
local coq = require'coq'

local configs = {}

-- {{{ Nvim LSP
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
-- }}}

-- {{{ Coq-nvim
for name, config in pairs(configs) do
  lspconfig[name].setup(coq.lsp_ensure_capabilities(config))
end
-- }}}

-- {{{ Custom handler
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    focusable = false,
    max_width = 150
  }
)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 4,
    }
  }
)
-- }}}

-- vim: foldmethod=marker:foldlevel=0
