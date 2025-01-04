---@type vim.lsp.Config
return {
  settings = {
    json = {
      validate = { enable = true },
    },
  },
  on_init = function(client, _initialize_result)
    require("jp.util").lsp_extend_settings(client, {
      json = { schemas = require("schemastore").json.schemas() },
    })
  end,
}
