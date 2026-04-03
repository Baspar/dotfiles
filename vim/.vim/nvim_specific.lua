-- Indent line
do
  require "ibl".setup {
    indent = { char = "┋" },
  }

  for _, keymap in pairs({ 'zc', 'zC', 'za', 'zA', 'zr', 'zR' }) do
    vim.api.nvim_set_keymap('n', keymap, keymap .. '<CMD>lua require("ibl").debounced_refresh(0)<CR>',
      { noremap = true, silent = true })
  end
end

-- FZF lua
do
  require("fzf-lua").setup {
    fzf_colors = {
      true,
    },
    winopts = {
      preview = {
        layout  = "vertical",
        winopts = {
          signcolumn = "no",
        }
      }
    }
  }
end

-- Leap.nvim
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

  local clever = require('leap.user').with_traversal_keys(';', '\\')

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

-- Treesitter node navigation
do
  vim.keymap.set({ 'x' }, '(', function()
    require 'vim.treesitter._select'.select_prev(vim.v.count1)
  end, { desc = 'Select previous node' })

  vim.keymap.set({ 'x' }, ')', function()
    require 'vim.treesitter._select'.select_next(vim.v.count1)
  end, { desc = 'Select next node' })

  vim.keymap.set({ 'x', 'o' }, '+', function()
    require 'vim.treesitter._select'.select_parent(vim.v.count1)
  end, { desc = 'Select parent (outer) node' })

  vim.keymap.set({ 'x', 'o' }, '-', function()
    require 'vim.treesitter._select'.select_child(vim.v.count1)
  end, { desc = 'Select child (inner) node' })
end

-- Cursorline
vim.o.cursorline = true
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  callback = function()
    vim.o.cursorlineopt = "both"
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  callback = function()
    vim.o.cursorlineopt = "number"
  end,
})
