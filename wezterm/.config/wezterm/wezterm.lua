local wezterm = require 'wezterm'

return {
  hide_tab_bar_if_only_one_tab = true,
  audible_bell = "Disabled",
  font_size = 20,
  font = wezterm.font{
    family= 'Haskplex Nerd',
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
  },
  keys = {
    -- CTRL-SHIFT-l activates the debug overlay
    { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
  },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_decorations = "RESIZE",
  cursor_blink_ease_in = "EaseInOut",
  cursor_blink_ease_out = "EaseInOut",
  cursor_blink_rate = 400,
  -- use_fancy_tab_bar = true,
  colors = {
    background = "#202020",
    foreground = "#ECE1D7",
    cursor_bg  = "#99826D",
    cursor_border  = "#99826D",
    cursor_fg  = "black",
    tab_bar = {
      background = "#202020",
      active_tab = {
        bg_color = "#af875f",
        fg_color = "#3e3e3e"
      },
      inactive_tab = {
        bg_color = "#3e3e3e",
        fg_color = "white"
      },
    },
    ansi = {
      "#352F2A",
      "#B65C60",
      "#78997A",
      "#EBC06D",
      "#9AACCE",
      "#B380B0",
      "#86A3A3",
      "#A38D78",
    },
    brights = {
      "#4D453E",
      "#F17C64",
      "#99D59D",
      "#EBC06D",
      "#9AACCE",
      "#CE9BCB",
      "#88B3B2",
      "#C1A78E",
    }
  }
}
