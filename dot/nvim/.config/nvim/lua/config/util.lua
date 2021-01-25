local M = {}

local keymap_opts = {noremap = true, silent = true}

M.set_keymap = function(mode, lhs, rhs, opts)
  opts = opts or keymap_opts
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

M.buf_set_keymap = function(bufnr, mode, lhs, rhs, opts)
  opts = opts or keymap_opts
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

M.set_maps = function(maps_args)
  for _, args in ipairs(maps_args) do
    M.set_keymap(unpack(args))
  end
end

M.buf_set_maps = function(bufnr, maps_args)
  for _, args in ipairs(maps_args) do
    M.buf_set_keymap(bufnr, unpack(args))
  end
end

M.clj_lsp_cmd = function(cmd, prompt)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local args = {vim.uri_from_bufnr(0) , cursor[1] - 1, cursor[2]}
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
