---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = { "lua/?.lua", "lua/?/init.lua" },
        pathStrict = true,
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      completion = {
        callSnippet = "Replace",
      },
      hint = {
        enable = true,
        setType = true,
      },
      format = { enable = false },
    },
  },
  on_init = function(client, _initialize_result)
    if client.root_dir and vim.uv.fs_stat(vim.fs.joinpath(client.root_dir, "init.lua")) then
      local library = {
        -- vim.fn.stdpath("config") .. "/lua",
        vim.fs.joinpath(vim.env.VIMRUNTIME, "lua"),
        "${3rd}/luv/library",
      }

      local deps_session = MiniDeps.get_session()
      local name_filter = {
        -- "SchemaStore.nvim",
        -- "blink.cmp",
        -- "conform.nvim",
        "catppuccin",
        "diffview.nvim",
        "mason.nvim",
        -- "mini.nvim",
        -- "nluarepl",
        -- "nvim-dap",
        -- "nvim-dap-virtual-text",
        -- "nvim-lint",
        -- "nvim-lspconfig",
        -- "nvim-nrepl",
        -- "nvim-treesitter-context",
        -- "nvim-treesitter-sexp",
        -- "nvim-treesitter",
      }
      for _, value in ipairs(deps_session) do
        local path = vim.fs.joinpath(value.path, "lua")
        if not vim.list_contains(name_filter, value.name) then
          if vim.uv.fs_stat(path) then library[#library + 1] = path end
        end
      end

      require("jp.util").lsp_extend_settings(client, {
        Lua = {
          workspace = {
            library = library,
            ignoreDir = {
              "test/",
              "tests/",

              "/catppuccin/*/",
              "catppuccin*.lua",
              "/conform/formatters/",
              "/lint/linters/",
              "/lspconfig/configs/",
              "/schemastore/catalog.lua",
            },
          },
        },
      })
    end
  end,
}
