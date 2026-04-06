local function custom_colors()
  vim.cmd("hi! Normal ctermbg=NONE guibg=NONE")
  vim.cmd("hi! Comment cterm=italic gui=italic")
  vim.cmd("hi! String cterm=italic gui=italic")

  local colors = {
    Red    = { bg = "#AF5F5E", fg = "#FFFFFF" },
    Yellow = { bg = "#AF875F", fg = "#FFFFFF" },
    Green  = { bg = "#A1B56C", fg = "#FFFFFF" },
  }

  if vim.o.background == "dark" then
    colors.RedSecondary    = { bg = "#703D3D", fg = "#FFFFFF" }
    colors.YellowSecondary = { bg = "#926E49", fg = "#FFFFFF" }
    colors.GreenSecondary  = { bg = "#38623E", fg = "#FFFFFF" }
    colors.Background      = { bg = "#202020", fg = "#ECE1D7" }
    colors.Furthest        = { bg = "#292827", fg = "#ECE1D7" }
    colors.Further         = { bg = "#3B3733", fg = "#C1A78E" }
    colors.Closer          = { bg = "#53483D", fg = "#B5A292" }
    colors.Closest         = { bg = "#AF875F", fg = "#3E3E3E" }
  else
    colors.RedSecondary    = { bg = "#A26865", fg = "#FFFFFF" }
    colors.YellowSecondary = { bg = "#A88B6D", fg = "#FFFFFF" }
    colors.GreenSecondary  = { bg = "#90A261", fg = "#FFFFFF" }
    colors.Background      = { bg = "#FCF3CF", fg = "#54433A" }
    colors.Furthest        = { bg = "#F4E7C2", fg = "#54433A" }
    colors.Further         = { bg = "#EBDAB4", fg = "#7C6F65" }
    colors.Closer          = { bg = "#D4C4A2", fg = "#7C6F65" }
    colors.Closest         = { bg = "#7C6F65", fg = "#FBF0C9" }
  end

  for name, c in pairs(colors) do
    for reverse_suffix, reverse_c in pairs({ [""] = { c.bg, c.fg }, ["_reverse"] = { c.fg, c.bg } }) do
      local bg, fg = reverse_c[1], reverse_c[2]
      for gui_suffix, gui in pairs({ [""] = "", ["_bold"] = " gui=bold", ["_italic"] = " gui=italic", ["_bold_italic"] = " gui=bold,italic" }) do
        vim.cmd(string.format("hi! %s%s%s guibg=%s guifg=%s%s", name, "", reverse_suffix .. gui_suffix, bg, fg, gui))
        vim.cmd(string.format("hi! %s%s%s guibg=%s%s", name, "_bg", reverse_suffix .. gui_suffix, bg, gui))
        vim.cmd(string.format("hi! %s%s%s guifg=%s%s", name, "_fg", reverse_suffix .. gui_suffix, fg, gui))
      end
    end
  end

  if vim.o.background == "dark" then
    vim.cmd(string.format("hi! Whitespace gui=italic guifg=%s", "#4D453E"))
  else
    vim.cmd(string.format("hi! Whitespace gui=italic guifg=%s", "#D5C4A3"))
  end

  vim.cmd("hi! link CurSearch YellowSecondary_bold")
  vim.cmd("hi! link LeapLabel RedSecondary")
  vim.cmd("hi! link Search RedSecondary")
  vim.cmd("hi! link LineNr Further")
  vim.cmd("hi! link CursorLineNr Closer")
  vim.cmd("hi! link CursorLine Furthest_bg")
  vim.cmd("hi! link WinSeparator Further_fg_reverse")
  vim.cmd("hi! link TabLine Further")
  vim.cmd("hi! link TabLineFill Furthest")
  vim.cmd("hi! link TabLineSel Closer_bold")
  vim.cmd("hi! link Folded Closer")
  vim.cmd("hi! link NotifyBackground Further")
  vim.cmd("hi! link NotifyBackgroundSecondary Closer")
  vim.cmd("hi! link FzfBackground NotifyBackground")
  vim.cmd("hi! link FzfLuaNormal NotifyBackground")
  vim.cmd("hi! link FzfLuaBorder NotifyBackground")
  vim.cmd("hi! link FzfBackgroundSelected NotifyBackgroundSecondary")
  vim.cmd("hi! link FzfLuaPreviewNormal NotifyBackgroundSecondary")
  vim.cmd("hi! link FzfLuaCursorLineNr Folded")
  vim.cmd("hi! link Sneak Closest")
  vim.cmd("hi! link HighlightCurrentWord Further_bg")
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "FocusGained" }, {
  callback = custom_colors,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "CustomColors",
  callback = custom_colors,
})

vim.cmd("colorscheme melange")
