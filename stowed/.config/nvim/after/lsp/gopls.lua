---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      codelenses = {
        gc_details = true,
        test = true,
      },
      usePlaceholders = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
