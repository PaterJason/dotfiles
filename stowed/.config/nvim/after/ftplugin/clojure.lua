vim.g.clojure_fuzzy_indent_patterns = { "^with", "^def", "^let", "^comment$" }
vim.g.clojure_maxlines = 0
vim.g.clojure_align_subforms = 1

local function get_client()
  return vim.lsp.get_clients({
    bufnr = 0,
    name = "clojure_lsp",
  })[1]
end

local commands = {
  "drag-param-backward",
  "drag-param-forward",
  "add-missing-libspec",
  "cycle-coll",
  "cycle-keyword-auto-resolve",
  "clean-ns",
  "cycle-privacy",
  "create-test",
  "demote-fn",
  "drag-backward",
  "drag-forward",
  "destructure-keys",
  "expand-let",
  "create-function",
  "get-in-all",
  "get-in-less",
  "get-in-more",
  "get-in-none",
  "inline-symbol",
  "resolve-macro-as",
  "replace-refer-all-with-alias",
  "restructure-keys",
  "sort-clauses",
  "thread-first-all",
  "thread-first",
  "thread-last-all",
  "thread-last",
  "unwind-all",
  "unwind-thread",
  "forward-slurp",
  "forward-barf",
  "backward-slurp",
  "backward-barf",
  "raise-sexp",
  "kill-sexp",
}

vim.api.nvim_buf_create_user_command(0, "CljLsp", function(info)
  local command = info.args
  local position_params = vim.lsp.util.make_position_params(0, "utf-8")
  local client = get_client()
  if not client then return end
  client:exec_cmd({
    title = "CljLsp",
    command = command,
    arguments = {
      position_params.textDocument.uri,
      position_params.position.line,
      position_params.position.character,
    },
  }, {}, function(_err, _result, _context) end)
end, {
  desc = "Run clojure-lsp command",
  nargs = 1,
  complete = function(arg_lead, _cmd_line, _cursor_pos)
    return vim.tbl_filter(function(s) return s:sub(1, #arg_lead) == arg_lead end, commands)
  end,
})

vim.api.nvim_buf_create_user_command(0, "CljDoc", function(_info)
  local client = get_client()
  if not client then return end
  client:request(
    "clojure/cursorInfo/raw",
    vim.lsp.util.make_position_params(0, "utf-8"),
    function(_err, result, _context)
      if result then
        local element = result.elements[1]
        local ns = element.definition.ns
        if ns and string.match(ns, "^clojure%.") then
          local url = string.format("https://clojuredocs.org/%s/%s", ns, element.definition.name)
          vim.ui.open(url)
        end
      end
    end,
    0
  )
end, {
  desc = "Open ClojureDocs",
  nargs = 0,
})
