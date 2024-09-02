MiniDeps.later(function()
  MiniDeps.add({ source = "tpope/vim-abolish" })

  MiniDeps.add({ source = "tpope/vim-sleuth" })

  MiniDeps.add({ source = "tpope/vim-eunuch" })

  vim.g.fugitive_legacy_commands = 0
  MiniDeps.add({ source = "tpope/vim-fugitive" })
end)
