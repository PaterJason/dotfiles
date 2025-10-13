---@type vim.lsp.Config
return {
  settings = {
    emmylua = {
      codeAction = {
        insertSpace = true,
      },
      completion = {
        callSnippet = true,
      },
      format = {
        externalTool = {
          program = 'stylua',
          args = {
            '-',
            '--stdin-filepath',
            '${file}',
          },
        },
      },
      signature = {
        detailSignatureHelper = true,
      },
      strict = {
        typeCall = true,
        arrayIndex = true,
        requirePath = true,
      },
    },
  },
  before_init = function(params, config)
    local root_dir = params.rootPath
    if root_dir == nil then return end
    local is_nvim = function(s) return vim.fs.basename(s) == 'nvim' end
    if is_nvim(root_dir) or vim.iter(vim.fs.parents(root_dir)):find(is_nvim) ~= nil then
      require('util').lsp_extend_config(config, {
        emmylua = {
          runtime = {
            version = 'LuaJIT',
            requirePattern = {
              'lua/?.lua',
              'lua/?/init.lua',
            },
          },
          workspace = {
            library = { vim.env.VIMRUNTIME },
          },
        },
      })
    end
  end,
  ---@type table<string,fun(command: lsp.Command, ctx: table)>
  commands = {
    ['editor.action.showReferences'] = function(command, _ctx)
      local items = vim.lsp.util.locations_to_items(command.arguments[3], 'utf-8')
      vim.fn.setqflist({}, ' ', {
        items = items,
        title = ('%s (%s)'):format(command.command, command.title),
      })
      vim.cmd('copen')
    end,
  },
}
