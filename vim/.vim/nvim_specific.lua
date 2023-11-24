require"ibl".setup()

for _, keymap in pairs({'zc', 'zC', 'za', 'zA', 'zr', 'zR'}) do
    vim.api.nvim_set_keymap('n', keymap,  keymap .. '<CMD>lua require("ibl").debounced_refresh(0)<CR>', { noremap=true, silent=true })
end

function parsecolor(c)
  return tonumber(c, 16) / tonumber(string.rep('f', #c), 16)
end

vim.api.nvim_create_autocmd({"FocusGained","BufWinEnter","WinEnter","WinNew","BufEnter"}, {
  callback = function()
    vim.api.nvim_create_autocmd('TermResponse', {
      once = true,
      callback = function(args)
        local resp = args.data
        local r, g, b
        r, g, b = resp:match("\x1b%]11;rgb:(%x+)/(%x+)/(%x+)")

        local rr = parsecolor(r)
        local gg = parsecolor(g)
        local bb = parsecolor(b)

        local luminance = (0.299 * rr) + (0.587 * gg) + (0.114 * bb)
        local bg = luminance < 0.5 and 'dark' or 'light'

        if bg ~= vim.o.background then
          vim.o.background = bg
          vim.cmd("doautocmd User CustomColors")
          require"ibl".setup()
        end
      end,
    })
    io.stdout:write("\x1b]11;?\x07")
  end
})
