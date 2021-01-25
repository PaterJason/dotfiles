function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

require'colorizer'.setup{
  '*';
  css = { css = true; };
  scss = { css = true; };
  '!vim-plug';
  '!fugitive';
}
require'config.lsp'
require'config.telescope'
require'config.treesitter'
require'config.compe'
