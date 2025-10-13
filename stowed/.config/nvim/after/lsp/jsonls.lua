---@type vim.lsp.Config
return {
  settings = {
    json = {
      validate = { enable = true },
    },
  },
  before_init = function(_params, config)
    require('util').lsp_extend_config(config, {
      json = { schemas = require('schemastore').json.schemas() },
    })
  end,
}
