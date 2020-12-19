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
require('_completion')
require('_lsp')
require('_telescope')
require('_treesitter')
