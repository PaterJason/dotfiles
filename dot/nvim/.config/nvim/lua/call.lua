local M = {}

M.clj_lsp_cmd = function(cmd, prompt)
  local params = vim.lsp.util.make_position_params()
  local args = {params.textDocument.uri , params.position.line, params.position.character}
  if prompt then
    local input = vim.fn.input(prompt)
    table.insert(args, input)
  end
  vim.lsp.buf.execute_command({
      command = cmd,
      arguments = args,
    })
end

return M
