MiniDeps.later(function()
  MiniDeps.add({
    source = "neovim/nvim-lspconfig",
    depends = {
      "b0o/SchemaStore.nvim",
      "nanotee/sqls.nvim",
    },
  })

  local lspconfig = require("lspconfig")

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  ---@type table<string, lspconfig.Config>
  local server_settings = {
    cssls = {},
    eslint = {},
    html = {},
    htmx = {},
    jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },
    bashls = {},
    gopls = {
      settings = {
        gopls = {
          codelenses = {
            gc_details = true,
          },
          usePlaceholders = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          hint = { enable = true },
          format = { enable = false },
        },
      },
      on_init = function(client)
        if vim.uv.fs_stat(vim.fs.joinpath(client.root_dir, "init.lua")) then
          local library = vim.api.nvim_get_runtime_file("lua/", true)
          library[#library+1] = "${3rd}/luv/library"
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            workspace = {
              library = library,
              ignoreDir = {
                "/catppuccin/*/",
                "catppuccin*.lua",
                "/cmp_*/",
                "/conform/formatters/",
                "/conjure/",
                "/lint/linters/",
                "/lspconfig/server_configurations/",
                "/mason-*/",
                "/mason/*/",
                "/nvim-web-devicons/",
                "/schemastore/catalog.lua",
                "/neodev.nvim/",
                "/rustaceanvim/",
                "/sqls/",
              },
            },
          })
        end
      end,
    },
    sqls = {
      on_attach = function(client, bufnr) require("sqls").on_attach(client, bufnr) end,
    },
    templ = {},
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
            includeInlayVariableTypeHints = true,
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
            includeInlayVariableTypeHints = true,
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
          catalogs = { vim.fs.normalize("~/.config/fontconfig/catalog.xml") },
        },
      },
    },
    marksman = {},
  }
  for server, config in pairs(server_settings) do
    config.capabilities = capabilities
    lspconfig[server].setup(config)
  end
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = "williamboman/mason.nvim",
    hooks = { post_checkout = function() vim.cmd("MasonUpdate") end },
  })

  require("mason").setup({
    ui = {
      border = "single",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
  vim.keymap.set("n", "<leader>m", vim.cmd.Mason, { desc = "Mason" })
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = "mrcjkb/rustaceanvim",
  })

  vim.g.rustaceanvim = {
    tools = {
      hover_actions = { replace_builtin_hover = false },
    },
    server = {
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = { "--", "-W", "clippy::pedantic" },
          },
          diagnostics = { warningsAsInfo = { "clippy::pedantic" } },
        },
      },
    },
  }
end)
