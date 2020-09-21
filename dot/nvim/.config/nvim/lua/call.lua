local M = {}

M.clj_lsp_cmd = function(cmd, prompt)
  local document_uri = "file://" .. vim.api.nvim_buf_get_name(0)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1
  local column = cursor[2]
  local args
  if prompt then
    local input = vim.api.nvim_eval("input('" .. prompt .. "')")
    args = {document_uri, line, column, input}
  else
    args = {document_uri, line, column}
  end
  vim.lsp.buf.execute_command({
      command = cmd,
      arguments = args,
    })
end

M.range_formatting = function()
  local start_pos = vim.api.nvim_eval("getpos(\"'<\")")
  local end_pos = vim.api.nvim_eval("getpos(\"'>\")")
  vim.lsp.buf.range_formatting({}, {start_pos[2], start_pos[3]}, {end_pos[2], end_pos[3]})
end

return M
