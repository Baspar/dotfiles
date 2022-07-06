require("indent_blankline").setup {
    char = "┋",
    use_treesitter = true,
    show_current_context = true,
    show_trailing_blankline_indent = false
}

for _, keymap in pairs({'zc', 'zC', 'za', 'zA', 'zr', 'zR'}) do
    vim.api.nvim_set_keymap('n', keymap,  keymap .. '<CMD>IndentBlanklineRefresh<CR>', { noremap=true, silent=true })
end
