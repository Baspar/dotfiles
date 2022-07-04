require("indent_blankline").setup {
    show_current_context = true,
}

for _, keymap in pairs({'zc', 'zC', 'za', 'zA', 'zr', 'zR'}) do
    vim.api.nvim_set_keymap('n', keymap,  keymap .. '<CMD>IndentBlanklineRefresh<CR>', { noremap=true, silent=true })
end
