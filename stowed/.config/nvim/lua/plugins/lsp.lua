local function config()
  local ih = require "lsp-inlayhints"
  ih.setup()

  local lspconfig = require "lspconfig"

  local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})
  local attach_augroup = vim.api.nvim_create_augroup("lsp_attach", {})
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)), "^conjure%-log%-%d+%.%a+$") then
        vim.diagnostic.disable(bufnr)
      end

      vim.api.nvim_clear_autocmds { group = attach_augroup, buffer = bufnr }
      ih.on_attach(client, bufnr, false)

      local capabilities = client.server_capabilities

      local t = package.loaded["telescope.builtin"]
      for _, value in ipairs {
        { "renameProvider", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame" },
        { "codeActionProvider", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction" },

        { "definitionProvider", "gd", t.lsp_definitions, "[G]oto [D]efinition" },
        { "referencesProvider", "gr", t.lsp_references, "[G]oto [R]eferences" },
        { "implementationProvider", "gI", t.lsp_implementations, "[G]oto [I]mplementation" },
        { "typeDefinitionProvider", "<leader>D", t.lsp_type_definitions, "Type [D]efinition" },
        { "documentSymbolProvider", "<leader>ds", t.lsp_document_symbols, "[D]ocument [S]ymbols" },
        { "workspaceSymbolProvider", "<leader>ws", t.lsp_workspace_symbols, "[W]orkspace [S]ymbols" },

        { "hoverProvider", "K", vim.lsp.buf.hover, "Hover Documentation" },
        { "signatureHelpProvider", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation" },

        { "declarationProvider", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration" },
        { "workspace", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder" },
        { "workspace", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder" },
        {
          "workspace",
          "<leader>wl",
          function()
            vim.notify(table.concat(vim.lsp.buf.list_workspace_folders(), ","))
          end,
          "[W]orkspace [L]ist Folders",
        },
        { "documentFormattingProvider", "<leader>f", vim.lsp.buf.format, "Format" },
      } do
        local cap, lhs, rhs, desc = unpack(value)
        if capabilities[cap] then
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
      end

      if capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd(
          "CursorHold",
          { callback = vim.lsp.buf.document_highlight, group = attach_augroup, buffer = bufnr }
        )
        vim.api.nvim_create_autocmd(
          { "CursorMoved", "ModeChanged" },
          { callback = vim.lsp.buf.clear_references, group = attach_augroup, buffer = bufnr }
        )
      end
      if capabilities.codeLensProvider then
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
      vim.lsp.codelens.clear(client.id)
      vim.lsp.buf.clear_references()
    end,
  })

  local capabilities = require("cmp_nvim_lsp").default_capabilities(lspconfig.util.default_config.capabilities)

  local server_settings = {
    cssls = {},
    eslint = {},
    html = {},
    jsonls = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
    bashls = {},
    clojure_lsp = {},
    lua_ls = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        hint = { enable = true },
        format = { enable = false },
        telemetry = { enable = false },
        workspace = {
          checkThirdParty = false,
          -- ignoreDir = { ".vscode", "conjure-log-*.lua" },
        },
      },
    },
    texlab = {
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
    taplo = {},
    tsserver = {
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
    yamlls = {
      yaml = {
        schemas = require("schemastore").yaml.schemas(),
      },
    },
    lemminx = {
      xml = {
        catalogs = { vim.fs.normalize "$HOME/.config/fontconfig/catalog.xml" },
      },
    },
    marksman = {},
  }
  for server, settings in pairs(server_settings) do
    lspconfig[server].setup {
      capabilities = capabilities,
      settings = settings,
    }
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- mason
      {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        build = ":MasonUpdate",
        config = function()
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
          vim.keymap.set("n", "<leader>m", "<Cmd>Mason<CR>", { desc = "Mason" })
        end,
      },

      -- lsp extras
      "lvimuser/lsp-inlayhints.nvim",

      -- language support
      "b0o/SchemaStore.nvim",
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup {}
        end,
      },
      {
        "simrat39/rust-tools.nvim",
        config = function()
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
        end,
      },
    },
    config = config,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = function()
      require("fidget").setup {}
    end,
  },
}
