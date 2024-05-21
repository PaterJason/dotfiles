local M = {}

function M.create_scratch(bufname)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, bufname)

  local ft = vim.filetype.match({ filename = bufname })
  vim.bo[buf].filetype = ft

  return buf
end

return M
