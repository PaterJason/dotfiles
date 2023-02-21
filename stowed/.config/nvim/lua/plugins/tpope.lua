return {
  "tpope/vim-abolish",
  -- "tpope/vim-commentary",
  {
    "tpope/vim-dispatch",
    config = function()
      vim.g.dispatch_no_maps = 1
    end,
  },
  "tpope/vim-eunuch",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-vinegar",
}
