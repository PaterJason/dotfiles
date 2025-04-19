local M = {}

---@param config vim.lsp.ClientConfig
---@param settings lsp.LSPObject
function M.lsp_extend_config(config, settings)
  for key, value in pairs(settings) do
    local setting = config.settings[key]
    if type(setting) == "table" then
      config.settings[key] = vim.tbl_deep_extend("force", setting, value)
    else
      config.settings[key] = value
    end
  end
end

return M
