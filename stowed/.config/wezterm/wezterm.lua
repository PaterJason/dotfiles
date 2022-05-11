local wezterm = require 'wezterm'

return {
  default_prog = { '/usr/bin/tmux', '-l' },

  color_scheme = 'ayu_light',

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
