---@type vim.lsp.Config
return {
  settings = {
    Lua = {
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
      codeLens = {
        enable = true,
      },
    },
  },
  before_init = function(params, config)
    local root_path = params.rootPath
    if type(root_path) ~= "string" then return end
    if
      not vim.tbl_isempty(vim.fs.find("nvim", {
        upward = true,
        path = root_path,
        type = "directory",
      }))
    then
      local library = {
        vim.fs.joinpath(vim.env.VIMRUNTIME, "lua"),
        "${3rd}/luv/library",
      }
      local settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = { "lua/?.lua", "lua/?/init.lua" },
            pathStrict = true,
          },
          workspace = {
            library = library,
          },
        },
      }

      if vim.uv.fs_stat(vim.fs.joinpath(root_path, "init.lua")) then
        for _, modname in pairs(vim.g.packages_loaded_at_startup) do
          local info = vim.loader.find(modname, {})[1]
          if info then
            local path = info.modpath
            if vim.startswith(path, MiniDeps.config.path.package) then
              library[#library + 1] = info.modpath
            end
          end
        end
        settings.Lua.workspace.ignoreDir = {
          "test/",
          "tests/",

          "/catppuccin/*/",
          "catppuccin*.lua",
          "/conform/formatters/",
          "/lint/linters/",
          "/lspconfig/",
          "/schemastore/catalog.lua",
        }
      end
      require("jp.util").lsp_extend_config(config, settings)
    end
  end,
}
