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
require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
    process_items = function(items, base)
      return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = 99 } })
    end
    ,
  },
})
vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
  once = true,
})
