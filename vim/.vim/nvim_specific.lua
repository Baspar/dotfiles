local ibl = require "ibl"
ibl.setup()
-- {
--     -- char = "┋",
--     -- use_treesitter = true,
--     -- show_current_context = true,
--     -- show_trailing_blankline_indent = false
-- }

for _, keymap in pairs({'zc', 'zC', 'za', 'zA', 'zr', 'zR'}) do
    vim.api.nvim_set_keymap('n', keymap,  keymap .. '<CMD>lua require("ibl").debounced_refresh(0)<CR>', { noremap=true, silent=true })
end
