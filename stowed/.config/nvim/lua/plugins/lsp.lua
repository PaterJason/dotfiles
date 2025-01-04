MiniDeps.later(function()
  MiniDeps.add({
    source = "neovim/nvim-lspconfig",
    depends = {
      "b0o/SchemaStore.nvim",
    },
  })

  for filename in vim.fs.dir(vim.fn.stdpath("config") .. "/lsp", {}) do
    local server = filename:gsub("%.lua$", "")

    local ok, default_config = pcall(
      function() return require("lspconfig.configs." .. server).default_config end
    )

    if ok then
      ---@type vim.lsp.Config
      local lsp_config = vim.deepcopy(default_config, true)
      lsp_config.root_dir = function(cb)
        local bufnr = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local get_root_dir = default_config.root_dir
        local async = require("lspconfig.async")
        async.run(function()
          local root_dir
          if type(get_root_dir) == "function" then
            root_dir = get_root_dir(vim.fs.normalize(bufname), bufnr)
            async.reenter()
            if not vim.api.nvim_buf_is_valid(bufnr) then return end
          elseif type(get_root_dir) == "string" then
            root_dir = get_root_dir
          end
          if root_dir then
            cb(root_dir)
          elseif default_config.single_file_support then
            local pseudo_root = #bufname == 0 and vim.loop.cwd()
              or vim.fs.dirname(vim.fs.normalize(bufname))
            cb(pseudo_root)
          end
        end)
      end

      vim.lsp.config(server, lsp_config)
    end
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
  vim.keymap.set("n", "<Leader>m", "<Cmd>Mason<CR>", { desc = "Mason" })
end)
