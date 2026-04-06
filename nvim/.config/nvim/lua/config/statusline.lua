local mode_map = {
  n = "NORMAL",
  i = "INSERT",
  R = "REPLACE",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  t = "TERMINAL",
}

local function is_special_buffer(filename)
  return filename:match("^NERD_tree_") or filename:match("^undotree") or filename:match("^diffpanel")
end

local function lsp_diagnostic_count(level)
  if not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0 })) then
    return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
  end
  return 0
end

local function line_info()
  local filename = vim.fn.expand("%:f")
  if is_special_buffer(filename) then
    return ""
  else
    return string.format("%d/%d:%d", vim.fn.line("."), vim.fn.line("$"), vim.fn.col("$") - 1)
  end
end

local function file_name()
  local out = {}
  local filename = vim.fn.expand("%:f")

  if filename == "" then
    table.insert(out, "[No name]")
  else
    table.insert(out, filename)
  end

  if vim.bo.readonly then
    table.insert(out, " ")
  end
  if vim.bo.modified then
    table.insert(out, "+")
  end

  return table.concat(out, "")
end

local function fugitive()
  if vim.fn.exists("*FugitiveHead") == 1 and vim.fn.FugitiveHead() ~= "" then
    return vim.fn.FugitiveHead()
  end
  return ""
end

local function get_mode()
  return mode_map[vim.fn.mode()] or ""
end

local function update_highlights()
  vim.cmd("hi! link StatusLineFileName LineNr")
  vim.cmd("hi! link StatusLineFileInfo Folded")
  vim.cmd("hi! link StatusLineLineInfo LineNr")
  vim.cmd("hi! link StatusLine LineNr")
  vim.cmd("hi StatusLine ctermbg=NONE guibg=NONE")
  vim.cmd("hi! link StatusLineNC StatusLine")
  vim.cmd("hi! link VertSplit WinSeparator")
  vim.cmd("hi! link StatusLineModeCommand Closest_bold")
  vim.cmd("hi! link StatusLineLspError Red")
  vim.cmd("hi! link StatusLineLspWarning Yellow")
  vim.cmd("hi! link StatusLineLspInfo Green")
end

local function set_statusline_active()
  local parts = {
    "%#StatusLineModeCommand#",
    " ",
    "%{v:lua.require'config.statusline'.get_mode()}",
    " ",
    "%#StatusLineFileInfo#",
    " %m ",
    "%#StatusLineFileName#",
    " %f ",
    "%#VertSplit#",
    "%=",
    "%#StatusLineLspError#",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('ERROR')>0?' ':''}",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('ERROR')>0?v:lua.require'config.statusline'.lsp_diagnostic_count('ERROR'):''}",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('ERROR')>0?' ':''}",
    "%#StatusLineLspWarning#",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('WARN')>0?' ':''}",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('WARN')>0?v:lua.require'config.statusline'.lsp_diagnostic_count('WARN'):''}",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('WARN')>0?' ':''}",
    "%#StatusLineLspInfo#",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('INFO')>0?' ':''}",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('INFO')>0?v:lua.require'config.statusline'.lsp_diagnostic_count('INFO'):''}",
    "%{v:lua.require'config.statusline'.lsp_diagnostic_count('INFO')>0?' ':''}",
    "%#StatusLineLineInfo#",
    " ",
    "%{v:lua.require'config.statusline'.line_info()}",
    " ",
    "%#StatusLineFileInfo#",
    "  ",
    "%#StatusLineModeCommand#",
    " ",
    "%{v:lua.require'config.statusline'.fugitive()}",
    " ",
  }
  vim.wo.statusline = table.concat(parts, "")
end

local function set_statusline_inactive()
  local parts = {
    "%#StatusLineFileName#",
    " %f%m ",
    "%#VertSplit#",
    "%=",
  }
  vim.wo.statusline = table.concat(parts, "")
end

local function set_statusline_simple()
  local parts = {
    "%#StatusLineModeCommand#",
    " ",
    "%{v:lua.require'config.statusline'.file_name()}",
    " ",
    "%#Normal#",
  }
  vim.wo.statusline = table.concat(parts, "")
end

local function update_statusline(active)
  update_highlights()

  local filename = vim.fn.expand("%:f")
  if is_special_buffer(filename) then
    set_statusline_simple()
  elseif active then
    set_statusline_active()
  else
    set_statusline_inactive()
  end
end

vim.api.nvim_create_autocmd({ "ColorScheme", "FocusLost", "WinLeave", "BufLeave" }, {
  callback = function()
    update_statusline(false)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufWinEnter", "WinEnter", "WinNew", "BufEnter", "VimEnter", "InsertEnter", "InsertChange", "InsertLeave" }, {
  callback = function()
    update_statusline(true)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "CustomColors", "NerdTreeOpen" },
  callback = function()
    update_statusline(true)
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  callback = function()
    vim.o.cursorlineopt = "both"
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.o.cursorlineopt = "number"
  end,
})

return {
  get_mode = get_mode,
  lsp_diagnostic_count = lsp_diagnostic_count,
  line_info = line_info,
  file_name = file_name,
  fugitive = fugitive,
}
