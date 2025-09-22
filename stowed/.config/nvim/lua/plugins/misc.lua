require('catppuccin').setup({
  default_integrations = false,
  integrations = {
    dap = true,
    markdown = true,
    mini = {
      enabled = true,
      indentscope_color = 'overlay0',
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
        ok = { 'italic' },
      },
      underlines = {
        errors = { 'underline' },
        hints = { 'underline' },
        warnings = { 'underline' },
        information = { 'underline' },
        ok = { 'underline' },
      },
      inlay_hints = {
        background = true,
      },
    },
    semantic_tokens = true,
    treesitter = true,
    treesitter_context = true,
  },
})
vim.cmd('colorscheme catppuccin')

require('oil').setup({
  view_options = {
    show_hidden = true,
  },
  float = { border = 'single' },
  confirmation = { border = 'single' },
  progress = { border = 'single' },
  ssh = { border = 'single' },
  keymaps_help = { border = 'single' },
})
vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '_', '<Cmd>Oil ./<CR>', { desc = 'Open current working directory' })
