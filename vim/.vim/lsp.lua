local lspconfig = require'lspconfig'
local null_ls = require'null-ls'
local fidget = require'fidget'
local cmp = require'cmp'
local cmp_nvim_lsp = require'cmp_nvim_lsp'
local lspkind = require'lspkind'

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

-- {{{ Scala [Disabled]
-- local scala_capabilities = vim.lsp.protocol.make_client_capabilities()
-- scala_capabilities.textDocument.codeAction = {
--   dynamicRegistration = false;
--   codeActionLiteralSupport = {
--     codeActionKind = {
--       valueSet = {
--         "",
--         "quickfix",
--         "refactor",
--         "refactor.extract",
--         "refactor.inline",
--         "refactor.rewrite",
--         "source",
--         "source.organizeImports",
--       };
--     };
--   };
-- }
-- configs['metals'] = {
--   root_dir = lspconfig.util.find_git_ancestor;
--   capabilities = scala_capabilities;
-- }
-- }}}

-- {{{ Python
configs['pyright'] = {}
-- }}}

-- {{{ C++
configs['clangd'] = {}
-- }}}

-- {{{ Bash
configs['bashls'] = {}
-- }}}

-- {{{ Vim
configs['vimls'] = {}
-- }}}

-- {{{ LUA
configs['sumneko_lua'] = {}
-- }}}

-- {{{ Go
configs['gopls'] = {}
-- }}}

-- {{{ Smithy [Disabled]
-- configs['smithy_lsp'] = {}
-- }}}

-- {{{ Groovy [Disabled]
-- configs['groovyls'] = {
--   cmd = { "java", "-jar", "/Users/bastien/.vim/lsp-servers/groovy-language-server-all.jar" },
-- }
-- }}}
-- }}}

-- {{{ nvim-cmp
cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'buffer' },
  }, {
  }),
  preselect = cmp.PreselectMode.None,
  view = {
    entries = 'native'
  },
  formatting = {
    format = function(entry, vim_item)
      if vim.tbl_contains({ 'path' }, entry.source.name) then
        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
        if icon then
          vim_item.kind = icon
          vim_item.kind_hl_group = hl_group
          return vim_item
        end
      end
      return lspkind.cmp_format({ with_text = false })(entry, vim_item)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-l>'] = cmp.mapping.confirm({select = true}),
  }),
  experimental = {
    ghost_text = true
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  }
})
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

for name, _ in pairs(configs) do
  lspconfig[name].setup {
    capabilities = cmp_nvim_lsp.default_capabilities()
  }
end

-- vim: foldmethod=marker:foldlevel=0
