function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.termguicolors = true

require 'init'
require 'plugins'
