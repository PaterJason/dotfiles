local lspconfig = require 'lspconfig'
local util = require'util'

vim.cmd("autocmd BufEnter * lua require'completion'.on_attach()")

vim.g.diagnostic_enable_virtual_text = 1
vim.g.diagnostic_auto_popup_while_jump = 0

vim.g.completion_sorting = 'length'
vim.g.completion_auto_change_source = 1
vim.g.completion_enable_snippet = 'vim-vsnip'
vim.g.completion_chain_complete_list = {
  default = {
    {complete_items = {'lsp', 'snippet'}},
    {mode = '<c-p>'},
    {mode = '<c-n>'},
  },
  clojure = {
    {complete_items = {'conjure', 'lsp', 'snippet'}},
    {mode = '<c-p>'},
    {mode = '<c-n>'},
  },
}

local clj_map = function(bufnr)
  local mappings = {
    ['<leader>rcc'] = "'cycle-coll'",
    ['<leader>rth'] = "'thread-first'",
    ['<leader>rtt'] = "'thread-last'",
    ['<leader>rtf'] = "'thread-first-all'",
    ['<leader>rtl'] = "'thread-last-all'",
    ['<leader>ruw'] = "'unwind-thread'",
    ['<leader>rua'] = "'unwind-all'",
    ['<leader>rml'] = "'move-to-let', 'Binding name: '",
    ['<leader>ril'] = "'introduce-let', 'Binding name: '",
    ['<leader>rel'] = "'expand-let'",
    ['<leader>ram'] = "'add-missing-libspec'",
    ['<leader>rcn'] = "'clean-ns'",
    ['<leader>rcp'] = "'cycle-privacy'",
    ['<leader>ris'] = "'inline-symbol'",
    ['<leader>ref'] = "'extract-function', 'Function name: '",
  }

  for lhs, args in pairs(mappings) do
    util.buf_set_keymap(bufnr, 'n', lhs, "<cmd>lua require'util'.clj_lsp_cmd(" .. args ..")<CR>")
  end
end

local on_attach = function(client, bufnr)
  local name = client.name
  print(name .. " attached")

  util.buf_set_maps(bufnr, {
      {'n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
      {'n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
      {'n', '<leader>dd', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'},
      {'n', '<leader>dl', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>'},
    })

  local capability_mappings = {
    code_action = {
      {'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>'},
      {'v', '<leader>la', '<cmd>lua vim.lsp.buf.range_code_action()<CR>'},
    },
    declaration = {{'n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>'}},
    document_formatting = {{'n', '<leader>l=', '<cmd>lua vim.lsp.buf.formatting()<CR>'}},
    document_range_formatting = {{'v', '<leader>l=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>'}},
    document_symbol = {{'n', '<leader>ld', '<cmd>lua vim.lsp.buf.document_symbol()<CR>'}},
    find_references = {{'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>'}},
    goto_definition = {{'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>'}},
    hover = {{'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>'}},
    implementation = {{'n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>'}},
    rename = {{'n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>'}},
    signature_help = {{'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>'}},
    type_definition = {{'n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>'}},
    workspace_symbol = {{'n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>'}},
  }

  for capability, maps_args in pairs(capability_mappings) do
    if client.resolved_capabilities[capability] then
      util.buf_set_maps(bufnr, maps_args)
    end
  end
end

local servers = {
  bashls = {},
  clojure_lsp = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      clj_map(bufnr)
    end,
    init_options = {
      ["ignore-classpath-directories"] = true,
    }
  },
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = {"vim"}
        },
        workspace = {
          library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true}
        }
      }
    }
  },
  r_language_server = {},
  texlab = {},
  tsserver = {},
  vimls = {},
}

for name, config in pairs(servers) do
  lspconfig[name].setup(vim.tbl_extend('keep', config, {on_attach = on_attach}))
end
