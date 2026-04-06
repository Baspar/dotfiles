local M = {}

function M.fn()
  local exclude_ft = { "nerdtree", "fugitive", "fzf" }
  if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
    pcall(vim.fn.matchdelete, 481516)
    local current_word = vim.fn.expand("<cword>")
    current_word = vim.fn.escape(current_word, "\\/[]*~")
    vim.fn.matchadd("HighlightCurrentWord", "\\<" .. current_word .. "\\>", 0, 481516)
  end
end

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = M.fn,
})

return M
