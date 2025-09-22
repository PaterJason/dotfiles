local M = {}

---@param config vim.lsp.ClientConfig
---@param settings table
function M.lsp_extend_config(config, settings)
  for key, value in pairs(settings) do
    ---@cast config.settings table
    local setting = config.settings[key]
    if type(setting) == 'table' then
      config.settings[key] = vim.tbl_deep_extend('keep', setting, value)
    else
      config.settings[key] = value
    end
  end
end

return M
