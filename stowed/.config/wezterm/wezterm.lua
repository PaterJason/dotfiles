local wezterm = require 'wezterm'

return {
  default_prog = { '/usr/bin/tmux', '-l' },

  colors = {
    foreground = '#0E1116',
    background = '#ffffff',
    cursor_bg = '#044289',
    cursor_border = '#044289',
    cursor_fg = '#ffffff',
    selection_bg = '#dbe9f9',
    selection_fg = '#0E1116',

    ansi = { '#24292f', '#cf222e', '#116329', '#4d2d00', '#0969da', '#8250df', '#1b7c83', '#6e7781', },
    brights = { '#57606a', '#a40e26', '#1a7f37', '#633c01', '#218bff', '#a475f9', '#3192aa', '#8c959f', },
  },

  font = wezterm.font 'Monospace',
  font_size = 10.0,
  freetype_load_target = 'HorizontalLcd',

  enable_tab_bar = false,
  window_frame = {
    font = wezterm.font 'Monospace',
    font_size = 10.0,
  },

  enable_wayland = true,

  initial_rows = 43,
  initial_cols = 132,

  disable_default_key_bindings = true,
  disable_default_mouse_bindings = true,
}
