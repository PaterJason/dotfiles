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
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function()
  --     require("nvim-autopairs").setup {
  --       check_ts = true,
  --       enable_check_bracket_line = false,
  --     }
  --     require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
  --   end,
  -- },
}
