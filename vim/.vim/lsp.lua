local lspconfig = require'lspconfig'
local null_ls = require'null-ls'
local fidget = require'fidget'

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

configs['tsserver'] = {
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
  end,
  filetypes = tsFamily,
}
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint_d.with({
          extra_args = { "--config", "eslint.cdk.json" }
        }),
        null_ls.builtins.formatting.prettier
    },
})
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

-- {{{ C++
configs['clangd'] = {}
-- }}}

-- {{{ Go
configs['gopls'] = {}
-- }}}

-- {{{ Smithy
configs['smithy_lsp'] = {}
-- }}}

-- {{{ Groovy
-- configs['groovyls'] = {
--   cmd = { "java", "-jar", "/Users/bastien/.vim/lsp-servers/groovy-language-server-all.jar" },
-- }
-- }}}
-- }}}

-- {{{ Fidget
fidget.setup{
  text = {
    spinner = "dots"
  },
  align = {
    bottom = false
  },
  fmt = {
    stack_upwards = false
  }
}
-- }}}

-- {{{ Custom handler
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { max_width = 150, border = "single" }
)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    virtual_text = { spacing = 4 },
    border = "single"
  }
)
-- }}}

-- vim: foldmethod=marker:foldlevel=0
