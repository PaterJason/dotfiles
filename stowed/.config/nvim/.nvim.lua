---@type string[]
local library = {
  vim.env.VIMRUNTIME,
}
for _, plug_data in ipairs(vim.pack.get()) do
  if
    not vim.list_contains({
      'nvim-lspconfig',
    }, plug_data.spec.name) and vim.uv.fs_stat(vim.fs.joinpath(plug_data.path, 'lua')) ~= nil
  then
    library[#library + 1] = plug_data.path
  end
end

---@type vim.lsp.Config
local config = vim.lsp.config['emmylua_ls']
config.settings.emmylua.workspace = {
  library = library,
  ignoreGlobs = {
    'lua/catppuccin/*/**',
    'lua/**/catppuccin*.lua',
    'lua/conform/formatters/**',
    'lua/lint/linters/**',
    'lua/schemastore/catalog.lua',
  },
}

vim.lsp.config('emmylua_ls', config)
