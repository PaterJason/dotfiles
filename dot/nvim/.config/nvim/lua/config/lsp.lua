local lsp = require 'lspconfig'
local util = require'config.util'

vim.tbl_map(
  function (d)
    local hl_group = 'LSPDiagnostics' .. d
    local get_fg = function(env)
      return ' ' .. env .. 'fg=' .. vim.fn.synIDattr(vim.fn.hlID(hl_group), 'fg', env)
    end
    local hl = get_fg('cterm') .. get_fg('gui')
    vim.cmd('hi LspDiagnosticsDefault' .. d .. hl)
    vim.cmd('hi LspDiagnosticsUnderline' .. d .. hl)
    vim.fn.sign_define('LspDiagnosticsSign' .. d, {text = '', numhl = 'LspDiagnosticsDefault' .. d})
  end,
  {'Hint', 'Error', 'Warning', 'Information'})

vim.cmd('hi link LspReferenceRead Underline')
vim.cmd('hi link LspReferenceText Underline')
vim.cmd('hi link LspReferenceWrite Underline')

local clj_map = function(bufnr)
  local mappings = {
    ['<leader>rcc'] = [['cycle-coll']],
    ['<leader>rth'] = [['thread-first']],
    ['<leader>rtt'] = [['thread-last']],
    ['<leader>rtf'] = [['thread-first-all']],
    ['<leader>rtl'] = [['thread-last-all']],
    ['<leader>ruw'] = [['unwind-thread']],
    ['<leader>rua'] = [['unwind-all']],
    ['<leader>rml'] = [['move-to-let', 'Binding name: ']],
    ['<leader>ril'] = [['introduce-let', 'Binding name: ']],
    ['<leader>rel'] = [['expand-let']],
    ['<leader>ram'] = [['add-missing-libspec']],
    ['<leader>rcn'] = [['clean-ns']],
    ['<leader>rcp'] = [['cycle-privacy']],
    ['<leader>ris'] = [['inline-symbol']],
    ['<leader>ref'] = [['extract-function', 'Function name: ']],
    ['<leader>rai'] = [['add-import-to-namespace', 'Import name: ']],
  }

  for lhs, args in pairs(mappings) do
    util.buf_set_keymap(bufnr, 'n', lhs, [[<cmd>lua require'call'.clj_lsp_cmd(]] .. args ..')<CR>')
  end
end

local on_attach = function(client, bufnr)
  util.buf_set_maps(bufnr, {
      {'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
      {'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
      {'n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
      {'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'},
      {'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'},
      {'n', '<space>wl', '<cmd>lua dump(vim.lsp.buf.list_workspace_folders())<CR>'},
    })

  local capability_mappings = {
    call_hierarchy = {
      {'n','<leader>ci',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>'},
      {'n','<leader>co',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>'},
    },
    code_action = {
      {'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>'},
      {'v', '<leader>a', '<cmd>lua vim.lsp.buf.range_code_action()<CR>'},
    },
    declaration = {{'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>'}},
    document_formatting = {{'n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>'}},
    document_range_formatting = {{'v', '<leader>=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>'}},
    document_symbol = {{'n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<CR>'}},
    find_references = {{'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>'}},
    goto_definition = {{'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>'}},
    hover = {{'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>'}},
    implementation = {{'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>'}},
    rename = {{'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>'}},
    signature_help = {{'n', '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>'}},
    type_definition = {{'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>'}},
    workspace_symbol = {{'n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>'}},
  }

  for capability, maps_args in pairs(capability_mappings) do
    if client.resolved_capabilities[capability] then
      util.buf_set_maps(bufnr, maps_args)
    end
  end

  if client.resolved_capabilities.document_highlight then
    vim.cmd('autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()')
    vim.cmd('autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
  end

  print(client.name .. ' attached')
end

local sumneko_root_path = vim.fn.expand('~/src/lua-language-server')
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'

local servers = {
  bashls = {},
  clojure_lsp = {
    on_attach = function(client, bufnr)
      clj_map(bufnr)
      on_attach(client, bufnr)
    end,
    init_options = {
      ['ignore-classpath-directories'] = true,
    }
  },
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  sumneko_lua = {
    cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'};
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          }
        }
      }
    }
  },
  texlab = {},
  tsserver = {},
  vimls = {},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for name, config in pairs(servers) do
  lsp[name].setup(vim.tbl_extend('keep', config, {on_attach = on_attach, capabilities = capabilities}))
end
