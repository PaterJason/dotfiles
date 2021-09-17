function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

-- Bootstrap
local function bootstrap(user, repo)
  local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/'..repo
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd('!git clone https://github.com/'..user..'/'..repo..' '..install_path)
    vim.cmd('packadd '..repo)
  end
end
bootstrap('wbthomason', 'packer.nvim')
bootstrap('Olical', 'aniseed')
vim.g['aniseed#env'] = true

local fnl_status, _ = pcall(require, 'plugins')
if not fnl_status then
  print('Fennel config not loaded, try restarting')
end

-- require'pack'
