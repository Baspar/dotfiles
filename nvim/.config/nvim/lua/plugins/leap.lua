local function ft(key_specific_args)
  require("leap").leap(vim.tbl_deep_extend("keep", key_specific_args, {
    inputlen = 1,
    inclusive = true,
    opts = {
      labels = "",
      safe_labels = vim.fn.mode(1):match("o") and "" or nil,
    },
  }))
end

local clever = require("leap.user").with_traversal_keys(";", "\\")

vim.keymap.set({ "n", "x", "o" }, "f", function() ft({ opts = clever }) end)
vim.keymap.set({ "n", "x", "o" }, "F", function() ft({ backward = true, opts = clever }) end)
vim.keymap.set({ "n", "x", "o" }, "t", function() ft({ offset = -1, opts = clever }) end)
vim.keymap.set({ "n", "x", "o" }, "T", function() ft({ backward = true, offset = 1, opts = clever }) end)
