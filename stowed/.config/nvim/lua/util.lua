local M = {}

local keymap_opts = { noremap = true, silent = true }

function M.keymap(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts or keymap_opts)
end

function M.buf_keymap(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or keymap_opts)
end

function M.keymaps(keymaps)
  for _, keymap in ipairs(keymaps) do
    M.keymap(unpack(keymap))
  end
end

function M.buf_keymaps(bufnr, keymaps)
  for _, keymap in ipairs(keymaps) do
    M.buf_keymap(bufnr, unpack(keymap))
  end
end

function M.tcode(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

function M.feedkeys(s)
  vim.api.nvim_feedkeys(M.tcode(s), '', true)
end

return M
