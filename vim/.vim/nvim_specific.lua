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
