M = {
  ---@type vim.lsp.util.open_floating_preview.Opts
  floating_preview = {
    border = "single",
    title = "nREPL",
    focusable = false,
    focus_id = "nvim.nrepl",
  },
  middleware_params = {
    -- ["nrepl.middleware.print/print"] = "clojure.pprint/pprint",
  },
  -- Use debug handler
  ---@type boolean
  debug = false,
}

return M
