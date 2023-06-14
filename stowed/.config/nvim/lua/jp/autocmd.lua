local augroup = vim.api.nvim_create_augroup("JPConfig", {})

-- vim.api.nvim_create_autocmd("FocusGained", {
--   group = augroup,
--   callback = function()
--     if vim.fn.executable "gsettings" then
--       local color_scheme = vim.fn.system "gsettings get org.gnome.desktop.interface color-scheme"
--       color_scheme = string.gsub(color_scheme, "[%s']", "")
--
--       if color_scheme == "prefer-dark" and vim.o.background ~= "dark" then
--         vim.o.background = "dark"
--       elseif color_scheme == "default" and vim.o.background ~= "light" then
--         vim.o.background = "light"
--       end
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank { timeout = 500 }
  end,
})
