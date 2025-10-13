---@type vim.lsp.Config
return {
  settings = {},
  before_init = function(_params, config)
    require('util').lsp_extend_config(config, {
      yaml = {
        schemaStore = {
          enable = false,
          url = '',
        },
        schemas = require('schemastore').yaml.schemas(),
      },
    })
  end,
}
