---@type vim.lsp.Config
return {
  settings = {
    yaml = { schemas = require("schemastore").yaml.schemas() },
  },
  -- Doesn't seem to work
  -- on_init = function(client, initialize_result)
  --   require("jp.util").lsp_extend_settings(client, {
  --     yaml = { schemas = require("schemastore").yaml.schemas() },
  --   })
  -- end,
}
