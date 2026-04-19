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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.pack.add({
      "https://github.com/echasnovski/mini.notify",
      "https://github.com/nvim-lua/plenary.nvim",
      "https://github.com/nvimtools/none-ls.nvim",
      "https://github.com/hrsh7th/nvim-cmp",
      "https://github.com/hrsh7th/cmp-path",
      "https://github.com/hrsh7th/cmp-buffer",
      "https://github.com/hrsh7th/cmp-nvim-lsp",
      "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help",
      "https://github.com/hrsh7th/cmp-vsnip",
      "https://github.com/hrsh7th/vim-vsnip",
      "https://github.com/hrsh7th/vim-vsnip-integ",
      "https://github.com/rafamadriz/friendly-snippets",
    })

    require("null-ls").setup({})
    require("mini.notify").setup()

    local cmp = require("cmp")
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
  end,
  once = true,
})
