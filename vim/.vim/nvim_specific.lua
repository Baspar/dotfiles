require "ibl".setup {
  indent = { char = "┋" },
}

for _, keymap in pairs({ 'zc', 'zC', 'za', 'zA', 'zr', 'zR' }) do
  vim.api.nvim_set_keymap('n', keymap, keymap .. '<CMD>lua require("ibl").debounced_refresh(0)<CR>',
    { noremap = true, silent = true })
end

require("fzf-lua").setup {
  fzf_colors = {
    true,
  },
  winopts = {
    preview = {
      layout   = "vertical",
      winopts  = {
        signcolumn = "no",
      }
    }
  }
}

do
  local function ft(key_specific_args)
    require('leap').leap(
      vim.tbl_deep_extend('keep', key_specific_args, {
        inputlen = 1,
        inclusive = true,
        opts = {
          -- Force autojump.
          labels = '',
          -- Match the modes where you don't need labels (`:h mode()`).
          safe_labels = vim.fn.mode(1):match('o') and '' or nil,
        },
      })
    )
  end

  local clever = require('leap.user').with_traversal_keys(';', ',')

  vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
    ft { opts = clever }
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
    ft { backward = true, opts = clever }
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
    ft { offset = -1, opts = clever }
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
    ft { backward = true, offset = 1, opts = clever }
  end)
end
