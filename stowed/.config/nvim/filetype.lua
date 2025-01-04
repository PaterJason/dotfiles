vim.filetype.add({
  extension = {
    cljd = "clojure",
  },
  filename = {
    [".zprintrc"] = "clojure",
  },
  pattern = {
    [".*/%.config/zathura/.*"] = "zathurarc",
    [".*"] = function(path, bufnr)
      return vim.bo[bufnr]
          and vim.bo[bufnr].filetype ~= "bigfile"
          and vim.fn.getfsize(path) > (1024 * 500) -- 500 KB
          and "bigfile"
        or nil
    end,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit" },
  callback = function(_args) vim.wo.spell = true end,
  group = "JPConfig",
  desc = "Set spell",
})
