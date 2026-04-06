local M = {}

function M.duplicate()
  local old_buffer = vim.fn.getreg('"')
  vim.cmd("normal! `<v`>yP")
  vim.fn.setreg('"', old_buffer)
end

function M.duplicate_op()
  local old_buffer = vim.fn.getreg('"')
  vim.cmd("normal! `[v`]yP")
  vim.fn.setreg('"', old_buffer)
end

return M
