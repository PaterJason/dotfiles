vim.filetype.add({
  extension = {
    cljd = "clojure",
  },
  filename = {
    [".zprintrc"] = "clojure",
  },
  pattern = {
    [".*/%.config/zathura/.*"] = "zathurarc",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit" },
  callback = function() vim.wo.spell = true end,
  group = "JPConfig",
  desc = "Set spell",
})
