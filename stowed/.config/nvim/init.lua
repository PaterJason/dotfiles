pcall(function()
  require "impatient"
end)

require "options"
require "filetype"
require "plugins"
require "diagnostic"

if vim.g.neovide then
  require "neovide"
end
