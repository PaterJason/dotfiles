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

return M
