local function config()
  require("neodev").setup {}
  local ih = require "lsp-inlayhints"
  ih.setup()

  require("mason").setup {
    ui = {
      width = 0.8,
      height = 0.8,
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  }
  require("mason-lspconfig").setup()
  vim.keymap.set("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Mason" })

  local lspconfig = require "lspconfig"

  local augroup = vim.api.nvim_create_augroup("Lsp", {})
  local attach_augroup = vim.api.nvim_create_augroup("lsp_attach", {})
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      vim.api.nvim_clear_autocmds { group = attach_augroup, buffer = bufnr }
      ih.on_attach(client, bufnr, false)

      local caps = client.server_capabilities

      local t = package.loaded["telescope.builtin"]
      for _, value in ipairs {
        { "callHierarchyProvider", "<leader>li", t.lsp_incoming_calls, "Incoming calls" },
        { "callHierarchyProvider", "<leader>lo", t.lsp_outgoing_calls, "Outgoing calls" },
        { "codeActionProvider", "<leader>a", vim.lsp.buf.code_action, "Code actions" },
        { "declarationProvider", "gD", vim.lsp.buf.declaration, "Declaration" },
        { "definitionProvider", "gd", t.lsp_definitions, "Goto Definition" },
        { "documentFormattingProvider", "<leader>lf", vim.lsp.buf.format, "Format" },
        { "documentSymbolProvider", "<leader>ls", t.lsp_document_symbols, "Document symbols" },
        { "hoverProvider", "K", vim.lsp.buf.hover, "Hover" },
        { "implementationProvider", "gI", t.lsp_implementations, "Implementation" },
        { "referencesProvider", "gr", t.lsp_references, "References" },
        { "renameProvider", "<leader>r", vim.lsp.buf.rename, "Rename" },
        { "signatureHelpProvider", "gK", vim.lsp.buf.signature_help, "Signature help" },
        { "typeDefinitionProvider", "<leader>ld", t.lsp_type_definitions, "Type definitions" },
        { "workspaceSymbolProvider", "<leader>lw", t.lsp_workspace_symbols, "Workspace symbols" },
      } do
        local cap, lhs, rhs, desc = unpack(value)
        if caps[cap] then
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
      end

      if caps.documentHighlightProvider then
        vim.api.nvim_create_autocmd(
          "CursorHold",
          { callback = vim.lsp.buf.document_highlight, group = attach_augroup, buffer = bufnr }
        )
        vim.api.nvim_create_autocmd(
          "CursorMoved",
          { callback = vim.lsp.buf.clear_references, group = attach_augroup, buffer = bufnr }
        )
      end
      if caps.codeLensProvider then
        vim.api.nvim_create_autocmd(
          { "BufEnter", "TextChanged", "InsertLeave" },
          { callback = vim.lsp.codelens.refresh, group = attach_augroup, buffer = bufnr }
        )
        vim.lsp.codelens.refresh()
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      vim.api.nvim_clear_autocmds { group = attach_augroup, buffer = bufnr }
      -- for _, value in ipairs(keymaps) do
      --   local _, lhs, _, _ = unpack(value)
      --   vim.keymap.del("n", lhs, { buffer = bufnr })
      -- end
      -- vim.notify(client.name .. " detached", vim.log.levels.INFO)
    end,
  })

  lspconfig.util.default_config.capabilities =
    vim.tbl_extend("force", lspconfig.util.default_config.capabilities, require("cmp_nvim_lsp").default_capabilities())
  lspconfig.util.default_config.capabilities.textDocument.colorProvider = { dynamicRegistration = true }

  for server, cfg in pairs {
    cssls = {},
    eslint = {},
    html = {},
    jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },
    bashls = {},
    clojure_lsp = {},
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          hint = { enable = true },
          format = { enable = false },
          telemetry = { enable = false },
        },
      },
    },
    texlab = {
      settings = {
        texlab = {
          build = { onSave = true, forwardSearchAfter = true },
          forwardSearch = {
            onSave = true,
            executable = "zathura",
            args = { "--synctex-forward", "%l:1:%f", "%p" },
          },
          chktex = { onEdit = true, onOpenAndSave = true },
        },
      },
    },
    taplo = {},
    tsserver = {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    },
    yamlls = {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    },
    lemminx = {
      settings = {
        xml = {
          catalogs = { vim.fs.normalize "$HOME/.config/fontconfig/catalog.xml" },
        },
      },
    },
    marksman = {},
  } do
    lspconfig[server].setup(cfg)
  end

  do
    local extension_path = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    require("rust-tools").setup {
      server = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy", extraArgs = { "--", "-W", "clippy::pedantic" } },
            diagnostics = { warningsAsInfo = { "clippy::pedantic" } },
          },
        },
      },
      dap = { adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path) },
      tools = { inlay_hints = { auto = false } },
    }
  end

  local null_ls = require "null-ls"
  null_ls.setup {
    sources = {
      null_ls.builtins.formatting.stylua,
    },
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- mason
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- lsp extras
      "jose-elias-alvarez/null-ls.nvim",
      "lvimuser/lsp-inlayhints.nvim",

      -- language support
      "b0o/SchemaStore.nvim",
      "folke/neodev.nvim",
      "simrat39/rust-tools.nvim",
    },
    config = config,
  },
}
