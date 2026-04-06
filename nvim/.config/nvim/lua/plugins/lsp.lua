local null_ls = require("null-ls")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local configs = {
  html = {},
  ts_ls = {
    on_attach = function(client)
      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
      end
      if client.resolved_capabilities then
        client.resolved_capabilities.document_formatting = false
      end
    end,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescript.tsx", "typescriptreact" },
  },
  rust_analyzer = {},
  pyright = {},
  clangd = {},
  bashls = {},
  vimls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  jdtls = {},
  gopls = {
    settings = {
      gopls = {
        env = { GOFLAGS = "-tags=integration,bmc,bmc_process" },
      },
    },
  },
}

null_ls.setup({})

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "path" },
    { name = "vsnip" },
    { name = "buffer" },
  }),
  preselect = cmp.PreselectMode.None,
  view = { entries = "native" },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
    ["<C-j>"] = cmp.mapping.scroll_docs(4),
    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
  }),
  experimental = { ghost_text = true },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
})

require("mini.notify").setup()

for name, config in pairs(configs) do
  config.capabilities = cmp_nvim_lsp.default_capabilities()
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end
