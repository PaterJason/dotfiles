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
        showWord = "Disable",
      },
      diagnostics = {
        libraryFiles = "Disable",
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
        vim.fs.joinpath(vim.env.VIMRUNTIME, "lua"),
        "${3rd}/luv/library",
      }

      for _, modname in pairs(DEPS_MODNAMES) do
        local info = vim.loader.find(modname, {})[1]
        if info then
          local path = info.modpath
          if vim.startswith(path, MiniDeps.config.path.package) then
            library[#library + 1] = info.modpath
          end
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
