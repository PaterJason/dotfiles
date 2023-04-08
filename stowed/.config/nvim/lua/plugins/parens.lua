return {
  {
    "gpanders/nvim-parinfer",
    config = function()
      vim.g.parinfer_enabled = false
      vim.keymap.set("n", "<leader>tp", "<cmd>ParinferToggle!<CR>", { desc = "Toggle Parinfer" })
    end,
  },
  {
    "guns/vim-sexp",
    dependencies = "tpope/vim-sexp-mappings-for-regular-people",
    config = function()
      vim.g.sexp_enable_insert_mode_mappings = 0
    end,
  },
}
