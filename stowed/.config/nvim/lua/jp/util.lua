M = {}

---@param client vim.lsp.Client
---@param settings table
function M.lsp_extend_settings(client, settings)
  for key, value in pairs(settings) do
    ---@diagnostic disable-next-line: param-type-mismatch
    client.config.settings[key] = vim.tbl_deep_extend("force", client.config.settings[key], value)
  end
  client:notify(
    vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
    { settings = client.config.settings }
  )
end

return M
