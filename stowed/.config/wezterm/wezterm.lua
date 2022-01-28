local wezterm = require 'wezterm'
local HOME = os.getenv('HOME')

return {
  default_prog = {"/usr/bin/fish", "-l"},

  color_scheme_dirs = { HOME .. '/.local/share/nvim/site/pack/packer/start/tokyonight.nvim/extras'},
  color_scheme = 'wezterm_tokyonight_night',

  font = wezterm.font('Cascadia Code'),
  font_size = 11.0,
  freetype_load_target = 'HorizontalLcd',

  hide_tab_bar_if_only_one_tab = true,
  window_frame = {
    font = wezterm.font('Inter'),
    font_size = 11.0,
    active_titlebar_bg = "#15161E",
    inactive_titlebar_bg = "#15161E",
    -- inactive_tab_edge = "#570000",
  },

  enable_wayland = true,
}
