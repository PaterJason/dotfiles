local ts = require('nvim-treesitter')

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(args)
    ---@type "install"|"update"|"delete"
    local kind = args.data.kind
    ---@type vim.pack.Spec
    local spec = args.data.spec
    if spec.name == 'nvim-treesitter' and kind == 'update' then vim.cmd('TSUpdate') end
  end,
  group = 'JPConfig',
})

local ensure_installed = { 'regex', 'luap', 'printf', 'comment' }
for name, type in vim.fs.dir(vim.fs.joinpath(vim.env.VIMRUNTIME, 'queries')) do
  if type == 'directory' then ensure_installed[#ensure_installed + 1] = name end
end
ts.install(ensure_installed, {})

---@param bufnr integer
---@param lang string
local function start(bufnr, lang)
  if not vim.treesitter.language.add(lang) then return end
  vim.treesitter.start(bufnr, lang)
  if vim.treesitter.query.get(lang, 'folds') ~= nil then
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'
  end
  if vim.treesitter.query.get(lang, 'indents') ~= nil then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang == nil then return end
    start(args.buf, lang)
  end,
  group = 'JPConfig',
})

vim.api.nvim_create_user_command('TSInstallFt', function(_args)
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  assert(lang ~= nil, 'No language found for filetype')

  ts.install({ lang }, { summary = true }):wait(30000)
  start(0, lang)
end, {})

--- @diagnostic disable-next-line: param-type-not-match
require('treesitter-context').setup({
  enable = false,
  max_lines = 4,
})
vim.keymap.set(
  'n',
  'gC',
  function() require('treesitter-context').go_to_context() end,
  { silent = true, desc = 'Go to context' }
)
