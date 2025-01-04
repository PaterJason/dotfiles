---@type vim.lsp.Config
return {
  settings = {
    xml = {
      catalogs = { vim.fs.normalize("~/.config/fontconfig/catalog.xml") },
    },
  },
}
