local compe = require'compe'
local util = require'util'

compe.setup{
  source = {
    buffer = true,
    conjure = {priority = 1001},
    nvim_lsp = true,
    nvim_lua = true,
    path = true,
    vsnip = true,
  },
}

local keymap_opts = {silent = true, expr = true}
util.set_keymaps{
  {'i', '<C-CR>', 'compe#complete()', keymap_opts},
  {'i', '<CR>', [[compe#confirm('<CR>')]], keymap_opts},
  {'i', '<C-e>', [[compe#close('<C-e>')]], keymap_opts},
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif vim.fn.call('vsnip#available', {1}) == 1 then
    return t '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
    return t '<Plug>(vsnip-jump-prev)'
  else
    return t '<S-Tab>'
  end
end

util.set_keymaps{
  {'i', '<C-CR>', 'compe#complete()', keymap_opts},
  {'i', '<CR>', [[compe#confirm('<CR>')]], keymap_opts},
  {'i', '<C-e>', [[compe#close('<C-e>')]], keymap_opts},
  {'i', '<Tab>', 'v:lua.tab_complete()', {expr = true}},
  {'s', '<Tab>', 'v:lua.tab_complete()', {expr = true}},
  {'i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true}},
  {'s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true}},
}
