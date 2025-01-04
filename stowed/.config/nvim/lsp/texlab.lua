---@type vim.lsp.Config
return {
  settings = {
    texlab = {
      build = { onSave = true, forwardSearchAfter = true },
      forwardSearch = {
        onSave = true,
        executable = "zathura",
        args = { "--synctex-forward", "%l:1:%f", "%p" },
      },
      chktex = { onEdit = true, onOpenAndSave = true },
    },
  },
}
