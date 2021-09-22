vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.termguicolors = true

local function bootstrap(user, repo)
  local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/'..repo
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd('!git clone https://github.com/'..user..'/'..repo..' '..install_path)
  end
end
bootstrap('wbthomason', 'packer.nvim')
bootstrap('Olical', 'aniseed')
vim.g['aniseed#env'] = true
