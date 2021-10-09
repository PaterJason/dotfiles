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

local function bootstrap(user, repo)
  local url = 'https://github.com/' .. user .. '/' .. repo
  local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/' .. repo
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system { 'git', 'clone', '--depth', '1', url, install_path }
  end
end
bootstrap('wbthomason', 'packer.nvim')

require 'init'
require 'plugins'
