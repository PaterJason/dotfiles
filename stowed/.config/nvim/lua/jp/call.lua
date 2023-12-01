local M = {}

function M.foldtext()
  local foldtext = vim.treesitter.foldtext()
  if type(foldtext) == "table" then
    vim.list_extend(foldtext, { { "     ", {} }, { vim.v.foldend - vim.v.foldstart + 1 .. " lines", { "NonText" } } })
  end
  return foldtext
end

return M
