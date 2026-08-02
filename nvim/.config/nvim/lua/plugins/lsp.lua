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

for name, config in pairs(configs) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

require("mini.notify").setup()
