local M = {}

local keymap_opts = { noremap = true, silent = true }

function M.keymap(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts or keymap_opts)
end

function M.buf_keymap(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or keymap_opts)
end

function M.keymaps(coll)
  for _, args in ipairs(coll) do
    M.keymap(unpack(args))
  end
end

function M.buf_keymaps(bufnr, coll)
  for _, args in ipairs(coll) do
    M.buf_keymap(bufnr, unpack(args))
  end
end

function M.replace_termcodes(s)
  vim.api.nvim_replace_termcodes(s, true, true, true)
end

return M
