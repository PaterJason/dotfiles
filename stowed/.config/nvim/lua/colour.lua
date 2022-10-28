require("catppuccin").setup {
  flavour = "latte",
  integrations = {
    cmp = true,
    gitsigns = true,
    leap = true,
    telescope = true,
    treesitter_context = true,
    treesitter = true,
    which_key = true,

    dap = { enabled = true, enable_ui = true },
    native_lsp = { enabled = true },
  },
}

vim.cmd.colorscheme "catppuccin"

vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
