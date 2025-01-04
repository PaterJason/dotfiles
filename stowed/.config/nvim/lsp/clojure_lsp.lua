local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.experimental = {
  clojuredocs = true,
  cursorInfo = true,
  projectTree = true,
  serverInfo = true,
  testTree = true,
}

---@type vim.lsp.Config
return {
  capabilities = capabilities,
  commands = {
    ["code-lens-references"] = function(_command, _ctx) vim.lsp.buf.references() end,
  },
}
