local lspconfig = require'lspconfig'
local null_ls = require'null-ls'
local cmp = require'cmp'
local cmp_nvim_lsp = require'cmp_nvim_lsp'

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
    if client.resolved_capabilities then
      client.resolved_capabilities.document_formatting = false
    end
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
configs['lua_ls'] = {}
-- }}}

-- {{{ Java
configs['jdtls'] = {}
-- }}}

-- {{{ Go
configs['gopls'] = {
  settings = {
        gopls = {
            env = {
                GOFLAGS = "-tags=integration"
            }
        }
    }
}
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

-- {{{ LSP Status
require('mini.notify').setup()
-- require("fidget").setup {
--   notification = {
--     window = {
--       normal_hl = "MsgArea",
--       -- winblend = 0,
--       -- align_bottom = false,
--       y_padding = 1,
--       border = "rounded"
--     }
--   }
-- }

local client_notifs = {}

local function get_notif_data(client_id, token)
  if not client_notifs[client_id] then
    client_notifs[client_id] = {}
  end

  if not client_notifs[client_id][token] then
    client_notifs[client_id][token] = {}
  end

  return client_notifs[client_id][token]
end


local function format_title(title, client_name)
  return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
  return (percentage and percentage .. "%\t" or "") .. (message or "")
end

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

for name, config in pairs(configs) do
  config.capabilities =  cmp_nvim_lsp.default_capabilities()
  lspconfig[name].setup(config)
end

-- vim: foldmethod=syntax:foldlevel=0
