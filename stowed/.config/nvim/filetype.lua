vim.filetype.add({
  extension = {
    cljd = "clojure",
  },
  filename = {
    [".zprintrc"] = "clojure",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit" },
  callback = function() vim.opt_local.spell = true end,
  group = "JPConfig",
  desc = "Set spell",
})
