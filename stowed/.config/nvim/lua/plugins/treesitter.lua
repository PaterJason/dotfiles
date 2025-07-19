MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    depends = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
  })

  local ts = require("nvim-treesitter")

  local ensure_installed = { "regex", "luap", "luadoc", "printf", "comment" }
  for name, type in vim.fs.dir(vim.fs.joinpath(vim.env.VIMRUNTIME, "queries")) do
    if type == "directory" then ensure_installed[#ensure_installed + 1] = name end
  end
  ts.install(ensure_installed, {})

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)

      local available = ts.get_available()
      if not vim.list_contains(available, lang) then return end

      local installed = ts.get_installed()
      if not vim.list_contains(installed, lang) then return end
      vim.treesitter.start(args.buf, lang)
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end,
    group = "JPConfig",
  })

  vim.api.nvim_create_user_command("TSInstallFt", function(args)
    local filetype = vim.bo.filetype
    local lang = vim.treesitter.language.get_lang(filetype)
    if lang == nil then return end

    ts.install({ lang }, { summary = true })
  end, {})

  require("treesitter-context").setup({})
  vim.keymap.set(
    "n",
    "gC",
    function() require("treesitter-context").go_to_context() end,
    { silent = true, desc = "Go to context" }
  )
end)
