local M = {}

function M.get_client()
  return vim.lsp.get_clients({
    bufnr = 0,
    name = "clojure_lsp",
  })[1]
end

vim.lsp.handlers["clojure/serverInfo/raw"] = function(_err, result, _context) vim.print(result) end
function M.get_server_info()
  local client = M.get_client()
  client:request("clojure/serverInfo/raw", {}, nil, 0)
end

vim.lsp.handlers["clojure/cursorInfo/raw"] = function(_err, result, _context) vim.print(result) end
function M.get_cursor_info()
  local client = M.get_client()
  client:request("clojure/cursorInfo/raw", vim.lsp.util.make_position_params(0, "utf-8"), nil, 0)
end

function M.open_cljdoc()
  local client = M.get_client()
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
end

return M
