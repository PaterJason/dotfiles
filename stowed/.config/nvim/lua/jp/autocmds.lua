local augroup = vim.api.nvim_create_augroup("JPConfig", { clear = true })
local create = vim.api.nvim_create_autocmd

create({ "TextYankPost" }, {
  callback = function() vim.highlight.on_yank({ timeout = 250 }) end,
  group = augroup,
  desc = "Highlight on yank",
})

create({ "BufReadPre" }, {
  callback = function(info)
    local stat = vim.uv.fs_stat(info.match)
    if stat and stat.size > 262144 then
      vim.b.bigfile = true
      vim.b.did_ftplugin = 1
      -- vim.cmd.filetype("off")
      vim.cmd.syntax("off")
    end
  end,
  group = augroup,
  desc = "Large files",
})