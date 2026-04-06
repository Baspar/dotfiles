local M = {}

function M.get_tmux_pane(count)
  local panes = vim.fn.system("tmux list-panes")
  panes = vim.trim(panes)
  local pane_list = vim.split(panes, "\n")
  local filtered = vim.tbl_filter(function(v)
    return not v:match(".*(active)")
  end, pane_list)
  local mapped = vim.tbl_map(function(v)
    local parts = vim.split(v, " ")
    return parts[#parts]
  end, filtered)
  return mapped[count + 1]
end

function M.send_to(type)
  local pane = vim.g.repl_it_pane
  if type == "line" then
    vim.cmd("normal! '[V']\"ry")
  elseif type == "char" then
    vim.cmd("normal! `[v`]\"ry")
  else
    vim.cmd("normal! `<v`>\"ry")
  end

  vim.fn.system("tmux loadb -b replit -", vim.fn.getreg("r"))
  vim.fn.system(string.format('tmux pasteb -b replit -t "\\%s"', pane))
  vim.fn.system("tmux deleteb -b replit")
  vim.cmd("redraw!")
end

function M.normal_mode()
  vim.g.repl_it_pane = M.get_tmux_pane(vim.v.count)
  vim.opt.operatorfunc = "v:lua.require'utils.repl_it'.send_to"
  return "g@"
end

function M.visual_mode()
  vim.g.repl_it_pane = M.get_tmux_pane(vim.v.count)
  M.send_to(vim.fn.visualmode())
end

return M
