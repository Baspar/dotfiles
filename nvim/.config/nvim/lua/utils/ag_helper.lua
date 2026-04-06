local M = {}

function M.look_for_block()
  local old_buffer = vim.fn.getreg('"')
  vim.cmd("normal! `<v`>y")
  vim.cmd("FzfLua grep search=" .. vim.fn.getreg('"'))
  vim.fn.setreg('"', old_buffer)
end

function M.look_for_block_op()
  local old_buffer = vim.fn.getreg('"')
  vim.cmd("normal! `[v`]y")
  vim.cmd("FzfLua grep search=" .. vim.fn.getreg('"'))
  vim.fn.setreg('"', old_buffer)
end

return M
