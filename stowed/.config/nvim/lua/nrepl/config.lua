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
      ["print-dup"] = vim.NIL,
      ---@type integer|vim.NIL
      ["print-length"] = 50,
      ---@type integer|vim.NIL
      ["print-level"] = 10,
      ---@type "true"|vim.NIL
      ["print-meta"] = vim.NIL,
      ---@type "true"|vim.NIL
      ["print-namespace-maps"] = vim.NIL,
      ---@type "true"|vim.NIL
      ["print-readably"] = vim.NIL,
    },
    ---@type "true"|vim.NIL
    ["nrepl.middleware.print/stream?"] = "true",
    ---@type integer|vim.NIL
    ["nrepl.middleware.print/buffer-size"] = vim.NIL,
    ---@type integer|vim.NIL
    ["nrepl.middleware.print/quota"] = vim.NIL,
    ---@type string[]|vim.NIL
    ["nrepl.middleware.print/keys"] = vim.NIL,
    -- caught
    ---@type string|vim.NIL
    ["nrepl.middleware.caught/caught"] = "clojure.repl/pst",
    ---@type "true"|vim.NIL
    ["nrepl.middleware.caught/print?"] = vim.NIL,
  },
  -- Debug printing
  ---@type boolean
  debug = false,
}

return M
