vim.bo.omnifunc = "v:lua.vim.treesitter.query.omnifunc"

vim.api.nvim_buf_create_user_command(0, "QueryKeywordPrg", function(info)
  ---@type string
  local s = info.args
  s = s:gsub("\\", "")
  s = s:gsub("^not%-", "")
  vim.cmd("help treesitter-*-" .. s)
end, {
  desc = "QUERY HELP",
  nargs = 1,
})

vim.bo.keywordprg = ":QueryKeywordPrg"
