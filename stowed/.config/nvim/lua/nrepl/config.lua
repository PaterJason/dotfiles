---@class Nrepl.Config
local M = {
  ---@type vim.lsp.util.open_floating_preview.Opts
  floating_preview = {
    border = "single",
    title = "nREPL",
    focusable = true,
    focus_id = "nvim.nrepl",
    wrap = false,
  },
  middleware_params = {
    -- print
    ---@type string|vim.NIL
    ["nrepl.middleware.print/print"] = "nrepl.util.print/pr",
    ["nrepl.middleware.print/options"] = {
      ---@type "true"|vim.NIL
      ["print-dup"] = nil,
      ---@type integer|vim.NIL
      ["print-length"] = 50,
      ---@type integer|vim.NIL
      ["print-level"] = 10,
      ---@type "true"|vim.NIL
      ["print-meta"] = nil,
      ---@type "true"|vim.NIL
      ["print-namespace-maps"] = nil,
      ---@type "true"|vim.NIL
      ["print-readably"] = nil,
    },
    ---@type "true"|vim.NIL
    ["nrepl.middleware.print/stream?"] = "true",
    ---@type integer|vim.NIL
    ["nrepl.middleware.print/buffer-size"] = nil,
    ---@type integer|vim.NIL
    ["nrepl.middleware.print/quota"] = nil,
    ---@type string[]|vim.NIL
    ["nrepl.middleware.print/keys"] = nil,
    -- caught
    ---@type string|vim.NIL
    ["nrepl.middleware.caught/caught"] = "clojure.repl/pst",
    ---@type "true"|vim.NIL
    ["nrepl.middleware.caught/print?"] = nil,
  },
  -- Debug printing
  ---@type boolean
  debug = false,
}

return M
