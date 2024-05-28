M = {
  ---@type vim.lsp.util.open_floating_preview.Opts
  floating_preview = {
    border = "single",
    title = "nREPL",
    focusable = false,
    focus_id = "nvim.nrepl",
  },
  ---@class Nrepl.MiddlewareParams
  middleware_params = {
    -- print
    ["nrepl.middleware.print/print"] = "nrepl.util.print/pr",
    ["nrepl.middleware.print/options"] = {
      ["print-dup"] = nil,
      ["print-readably"] = nil,
      ["print-length"] = 50,
      ["print-level"] = 10,
      ["print-meta"] = nil,
      ["print-namespace-maps"] = nil,
    },
    ["nrepl.middleware.print/stream?"] = nil,
    ["nrepl.middleware.print/buffer-size"] = nil,
    ["nrepl.middleware.print/quota"] = nil,
    ["nrepl.middleware.print/keys"] = nil,
    -- caught
    ["nrepl.middleware.caught/caught"] = nil,
    ["nrepl.middleware.caught/print?"] = nil,
  },
  -- Use debug handler
  ---@type boolean
  debug = false,
}

return M
