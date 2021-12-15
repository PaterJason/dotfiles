local wk = require 'which-key'
wk.setup {
  plugins = {
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
    },
  },
}

wk.register({
  ['<leader>'] = { '<cmd>Telescope builtin<CR>', 'Telescope builtins' },
  h = { name = 'Gitsigns hunk' },
  l = { name = 'LSP' },
  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    C = { "<cmd>PackerClean<cr>", "Clean" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    S = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },
  s = {
    name = 'Telescope Search',
    b = { '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Current buffer' },
    f = { '<cmd>Telescope find_files<CR>', 'Find Files' },
    F = { '<cmd>lua require "telescope".extensions.file_browser.file_browser()<CR>', 'File Browser' },
    h = { '<cmd>Telescope help_tags<CR>', 'Help' },
    g = { '<cmd>Telescope live_grep<CR>', 'Grep' },
    G = { '<cmd>Telescope grep_string<CR>', 'Grep string' },
  },
  u = { '<cmd>UndotreeToggle<CR>', 'Undotree' },
}, {
  prefix = '<leader>',
})

wk.register({
  a = { '<Plug>(EasyAlign)', 'EasyAlign' },
  c = 'Comment',
}, { prefix = 'g' })

wk.register({
  a = { '<Plug>(EasyAlign)', 'EasyAlign' },
  c = 'Comment',
}, { mode = 'x', prefix = 'g' })
