local fzf = function()
  local fzf_lua = require("fzf-lua")

  fzf_lua.setup({
    fzf_colors = { true },
    winopts = {
      preview = {
        layout = "vertical",
        winopts = { signcolumn = "no" },
      },
    },
  })

  return fzf_lua
end

return {
  buffers = function() return fzf().buffers() end,
  git_files = function() return fzf().git_files() end,
  files = function() return fzf().files() end,
  grep = function(search) return fzf().grep({ search = search }) end,
}
