---@type vim.lsp.Config
return {
  settings = {
    yaml = {},
  },
  on_init = function(client, _initialize_result)
    require("jp.util").lsp_extend_settings(client, {
      yaml = { schemas = require("schemastore").yaml.schemas() },
    })
  end,
}
