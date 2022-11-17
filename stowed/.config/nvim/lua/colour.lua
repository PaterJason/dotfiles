require("catppuccin").setup {
  flavour = "latte",
  integrations = {
    cmp = true,
    gitsigns = true,
    leap = true,
    mason = true,
    telescope = true,
    treesitter = true,
    treesitter_context = true,
    which_key = true,

    dap = { enabled = true, enable_ui = true },
    native_lsp = { enabled = true },
  },
}

vim.cmd.colorscheme "catppuccin"
