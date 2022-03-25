local wezterm = require 'wezterm'
local HOME = os.getenv 'HOME'

return {
  default_prog = { '/usr/bin/tmux', '-l' },

  color_scheme_dirs = { HOME .. '/.local/share/nvim/site/pack/packer/start/tokyonight.nvim/extras' },
  color_scheme = 'wezterm_tokyonight_night',

  font = wezterm.font 'Monospace',
  font_size = 10.0,
  freetype_load_target = 'HorizontalLcd',

  hide_tab_bar_if_only_one_tab = true,
  window_frame = {
    font = wezterm.font 'Monospace',
    font_size = 10.0,
    active_titlebar_bg = '#15161E',
  },

  enable_wayland = true,

  initial_rows = 43,
  initial_cols = 132,

  disable_default_key_bindings = true,
  disable_default_mouse_bindings = true,
}
