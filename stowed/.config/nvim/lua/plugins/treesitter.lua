MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter",
    depends = {
      "nvim-treesitter/nvim-treesitter-context",
      "PaterJason/nvim-treesitter-sexp",
    },
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
  })

  local ensure_installed = {
    "comment",
    "regex",
  }
  for name, type in vim.fs.dir(vim.fs.joinpath(vim.env.VIMRUNTIME, "queries")) do
    if type == "directory" then ensure_installed[#ensure_installed + 1] = name end
  end

  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    ensure_installed = ensure_installed,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, bufnr)
        return vim.b[bufnr].bigfile == true
      end,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = false,
        node_incremental = "an",
        scope_incremental = "aN",
        node_decremental = "in",
      },
    },
    indent = {
      enable = true,
    },
  })

  vim.keymap.set(
    "n",
    "gC",
    function() require("treesitter-context").go_to_context() end,
    { silent = true, desc = "Go to context" }
  )
end)
