local function ft(key_specific_args)
  local clever = require("leap.user").with_traversal_keys(";", "\\")
  require("leap").leap(vim.tbl_deep_extend("keep", key_specific_args, {
    inputlen = 1,
    inclusive = true,
    opts = vim.tbl_deep_extend("keep",
      clever,
      {
        labels = "",
        safe_labels = vim.fn.mode(1):match("o") and "" or nil,
      }
    )
  }))
end

vim.keymap.set({ "n", "x", "o" }, "f", function() ft({}) end)
vim.keymap.set({ "n", "x", "o" }, "F", function() ft({ backward = true }) end)
vim.keymap.set({ "n", "x", "o" }, "t", function() ft({ offset = -1 }) end)
vim.keymap.set({ "n", "x", "o" }, "T", function() ft({ backward = true, offset = 1 }) end)
