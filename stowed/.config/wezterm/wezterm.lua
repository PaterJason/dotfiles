local wezterm = require 'wezterm'

local colors = {
  foreground = '#c0caf5',
  background = '#1a1b26',
  cursor_bg = '#c0caf5',
  cursor_border = '#c0caf5',
  cursor_fg = '#1a1b26',
  selection_bg = '#33467C',
  selection_fg = '#c0caf5',
  ansi = { '#15161E', '#f7768e', '#9ece6a', '#e0af68', '#7aa2f7', '#bb9af7', '#7dcfff', '#a9b1d6' },
  brights = { '#414868', '#f7768e', '#9ece6a', '#e0af68', '#7aa2f7', '#bb9af7', '#7dcfff', '#c0caf5' },
}

return {
  default_prog = { '/usr/bin/tmux', '-l' },

  colors = colors,

  font = wezterm.font 'Monospace',
  font_size = 10.0,
  freetype_load_target = 'HorizontalLcd',

  enable_tab_bar = false,
  window_frame = {
    font = wezterm.font 'Monospace',
    font_size = 10.0,

    inactive_titlebar_bg = colors.background,
    active_titlebar_bg = colors.ansi[1],
    inactive_titlebar_fg = colors.foreground,
    -- active_titlebar_fg = colors.foreground,
    inactive_titlebar_border_bottom = colors.ansi[1],
    active_titlebar_border_bottom = colors.ansi[1],
    button_fg = colors.foreground,
    button_bg = colors.ansi[1],
    button_hover_fg = colors.foreground,
    button_hover_bg = colors.background,
  },

  enable_wayland = true,

  initial_rows = 43,
  initial_cols = 132,

  disable_default_key_bindings = true,
  disable_default_mouse_bindings = true,
}
