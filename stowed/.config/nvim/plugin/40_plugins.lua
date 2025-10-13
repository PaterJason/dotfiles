-- Commands
vim.api.nvim_create_user_command('PackUpdate', function() vim.pack.update() end, {})
vim.api.nvim_create_user_command('PackClean', function()
  ---@type string[]
  local names = {}
  for _, plug_data in ipairs(vim.pack.get()) do
    if not plug_data.active then names[#names + 1] = plug_data.spec.name end
  end
  if #names == 0 then
    vim.notify('Nothing to remove', vim.log.levels.INFO)
    return
  end
  local is_confirmed = vim.fn.confirm(
    ('These plugins will be removed:\n\n%s\n'):format(table.concat(names, '\n')),
    'Proceed? &Yes\n&No',
    1,
    'Question'
  ) == 1
  if is_confirmed then vim.pack.del(names) end
end, {})

-- Options
vim.g.fugitive_legacy_commands = 0
