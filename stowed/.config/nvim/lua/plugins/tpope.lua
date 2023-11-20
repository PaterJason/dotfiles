---@type LazySpec
return {
  "tpope/vim-abolish",
  {
    "tpope/vim-dispatch",
    init = function()
      vim.g.dispatch_no_maps = 1
    end,
  },
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
}
