M = {
  ---@type vim.lsp.util.open_floating_preview.Opts
  floating_preview = {
    border = "single",
    title = "nREPL",
    focus_id = "nvim.nrepl",
  },
  -- Use debug handler
  ---@type boolean
  debug = false
}

return M
