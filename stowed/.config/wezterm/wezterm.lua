local wezterm = require "wezterm"

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

return {
  default_prog = { "/usr/bin/tmux", "-l" },
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
  font = wezterm.font {
    family = "Monospace",
    harfbuzz_features = { "zero" },
  },
  font_size = 10.0,
  freetype_load_target = "HorizontalLcd",
  enable_tab_bar = false,
  window_frame = {
    font = wezterm.font "Monospace",
    font_size = 10.0,
  },
  enable_wayland = true,
  initial_rows = 43,
  initial_cols = 132,
  disable_default_key_bindings = true,
  disable_default_mouse_bindings = true,
  warn_about_missing_glyphs = false,
}
