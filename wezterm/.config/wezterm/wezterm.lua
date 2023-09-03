local wezterm = require 'wezterm'

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local dark_colors = {
  background    = "#202020",
  foreground    = "#ECE1D7",
  cursor_bg     = "#99826D",
  cursor_border = "#99826D",
  cursor_fg     = "black",
  ansi          = {
    "#352F2A",
    "#B65C60",
    "#78997A",
    "#EBC06D",
    "#9AACCE",
    "#B380B0",
    "#86A3A3",
    "#A38D78",
  },
  brights       = {
    "#4D453E",
    "#F17C64",
    "#99D59D",
    "#EBC06D",
    "#9AACCE",
    "#CE9BCB",
    "#88B3B2",
    "#C1A78E",
  },
  tab_bar       = {
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
}

local light_colors = {
  foreground    = "#54433A",
  background    = "#FCF3CF",
  cursor_bg     = "#54433A",
  cursor_border = "#54433A",
  cursor_fg     = "#F1F1F1",
  selection_bg  = "#D9D3CE",
  selection_fg  = "#54433A",
  ansi          = {
    "#E9E1DB",
    "#C77B8B",
    "#6E9B72",
    "#BC5C00",
    "#7892BD",
    "#BE79BB",
    "#739797",
    "#7D6658",
  },
  brights       = {
    "#A98A78",
    "#BF0021",
    "#3A684A",
    "#A06D00",
    "#465AA4",
    "#904180",
    "#3D6568",
    "#54433A",
  },
  tab_bar       = {
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
}

local function get_colors(appearance)
  if appearance:find 'Dark' then
    return dark_colors
  else
    return light_colors
  end
end

return {
  hide_tab_bar_if_only_one_tab = true,
  audible_bell = "Disabled",
  font_size = 20,
  font = wezterm.font {
    family = 'Haskplex Nerd',
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
  use_fancy_tab_bar = true,
  colors = get_colors(get_appearance()),
}
