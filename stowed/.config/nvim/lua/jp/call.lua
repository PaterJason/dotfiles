local M = {}

function M.foldtext()
  if vim.opt_local.foldmethod:get() == "marker" then return vim.fn.foldtext() end

  local foldtext = vim.treesitter.foldtext()
  if type(foldtext) == "table" then
    local is_diagnostic = vim
      .iter(vim.diagnostic.get(0, {
        severity = { min = vim.diagnostic.severity.WARN },
      }))
      :any(
        ---@param diagnostic Diagnostic
        function(diagnostic) return diagnostic.lnum + 1 >= vim.v.foldstart and diagnostic.lnum + 1 <= vim.v.foldend end
      )

    foldtext[#foldtext + 1] = {
      " +"
        .. (is_diagnostic and "WE" or "--")
        .. string.sub(vim.v.folddashes, 2)
        .. " "
        .. vim.v.foldend - vim.v.foldstart + 1
        .. " lines",
      { "NonText" },
    }
  end
  return foldtext
end

return M
