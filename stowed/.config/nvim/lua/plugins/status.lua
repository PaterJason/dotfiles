require('lualine').setup {
  options = {
    theme = 'tokyonight',
    icons_enabled = false,
    section_separators = '',
    component_separators = '',
  },
  extensions = { 'fugitive', 'quickfix' },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
  },
}
