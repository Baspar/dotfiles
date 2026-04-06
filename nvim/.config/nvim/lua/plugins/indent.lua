require("ibl").setup({
  indent = { char = "┋" },
})

for _, keymap in pairs({ "zc", "zC", "za", "zA", "zr", "zR" }) do
  vim.keymap.set("n", keymap, keymap .. "<CMD>lua require('ibl').debounced_refresh(0)<CR>", { noremap = true, silent = true })
end
