MiniDeps.later(function() require("mini.extra").setup({}) end)

MiniDeps.later(
  function()
    require("mini.ai").setup({
      n_lines = 100,
      search_method = "cover",
      mappings = { around_next = "", inside_next = "", around_last = "", inside_last = "" },
      custom_textobjects = {
        f = false,
        B = MiniExtra.gen_ai_spec.buffer(),
        D = MiniExtra.gen_ai_spec.diagnostic(),
        I = MiniExtra.gen_ai_spec.indent(),
        L = MiniExtra.gen_ai_spec.line(),
        N = MiniExtra.gen_ai_spec.number(),
      },
    })
  end
)

MiniDeps.later(function() require("mini.align").setup({}) end)

MiniDeps.later(
  function()
    require("mini.basics").setup({
      options = { basic = false },
      mappings = { basic = false, option_toggle_prefix = "yo" },
      autocommands = { basic = false },
    })
  end
)

MiniDeps.later(
  function()
    require("mini.bracketed").setup({
      comment = { suffix = "/", options = {} },
    })
  end
)

MiniDeps.later(function()
  require("mini.bufremove").setup({})
  vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete buffer" })
  vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Wipeout buffer" })
end)

MiniDeps.later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "<LocalLeader>" },
      { mode = "x", keys = "<LocalLeader>" },
      -- Built-in completion
      { mode = "i", keys = "<C-x>" },
      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      -- Window commands
      { mode = "n", keys = "<C-w>" },
      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      -- MiniBasics
      { mode = "n", keys = "yo" },
      -- MiniBracketed
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
    },
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      config = {
        width = 60,
      },
    },
  })
end)

MiniDeps.later(function() require("mini.comment").setup({}) end)

MiniDeps.later(function()
  require("mini.diff").setup({})
  vim.keymap.set(
    "n",
    "<leader>td",
    function() MiniDiff.toggle_overlay(0) end,
    { desc = "toggle diff overlay" }
  )
end)

MiniDeps.now(function()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  require("mini.files").setup({
    mappings = {
      go_in = "L",
      go_in_plus = "l",
      go_out = "H",
      go_out_plus = "h",
    },
    windows = {
      max_number = 1,
      width_focus = 80,
    },
  })
  vim.keymap.set(
    "n",
    "-",
    function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end,
    { desc = "Open parent directory" }
  )
  vim.keymap.set(
    "n",
    "_",
    function() MiniFiles.open(nil, false) end,
    { desc = "Open current directory" }
  )
end)

MiniDeps.later(function()
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      hex_color = hipatterns.gen_highlighter.hex_color({}),
    },
  })
end)

MiniDeps.later(function() require("mini.jump").setup({}) end)

MiniDeps.now(function()
  require("mini.notify").setup({
    lsp_progress = {
      duration_last = 2500,
      enable = true,
    },
    window = {
      winblend = 0,
    },
  })
  vim.notify = MiniNotify.make_notify()
end)

MiniDeps.later(function() require("mini.pairs").setup({}) end)

MiniDeps.later(function()
  require("mini.pick").setup({
    mappings = { choose_marked = "<C-q>" },
  })
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set("n", "<leader>sb", MiniPick.builtin.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>sf", MiniPick.builtin.files, { desc = "Files" })
  vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep_live, { desc = "Grep live" })
  vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "Help tags" })
  vim.keymap.set("n", "<leader>sr", MiniPick.builtin.resume, { desc = "Resume" })

  vim.keymap.set("n", "<leader>gf", MiniExtra.pickers.git_files, { desc = "Git files picker" })
  vim.keymap.set(
    "n",
    "<leader>gb",
    MiniExtra.pickers.git_branches,
    { desc = "Git branches picker" }
  )
  vim.keymap.set("n", "<leader>gc", MiniExtra.pickers.git_commits, { desc = "Git commits picker" })
  vim.keymap.set("n", "<leader>gh", MiniExtra.pickers.git_hunks, { desc = "Git hunks picker" })

  vim.keymap.set(
    "n",
    "<leader>sd",
    MiniExtra.pickers.diagnostic,
    { desc = "Built-in diagnostic picker" }
  )
  vim.keymap.set(
    "n",
    "<leader>sl",
    function() MiniExtra.pickers.buf_lines({ scope = "current" }) end,
    { desc = "Buffer lines" }
  )

  vim.keymap.set("n", "<leader><leader>", function()
    local items = {}
    local scopes = {
      buf_lines = { "all", "current" },
      diagnostic = { "all", "current" },
      git_files = { "tracked", "modified", "untracked", "ignored", "deleted" },
      git_hunks = { "unstaged", "staged" },
      list = { "quickfix", "location" },
      lsp = {
        "declaration",
        "definition",
        "document_symbol",
        "implementation",
        "references",
        "type_definition",
        "workspace_symbol",
      },
    }
    for _, pickers in ipairs({ MiniPick.builtin, MiniExtra.pickers }) do
      for key, value in vim.spairs(pickers) do
        if scopes[key] then
          for _, scope in ipairs(scopes[key]) do
            items[#items + 1] = { builtin = key, callback = value, scope = scope }
          end
        else
          items[#items + 1] = { builtin = key, callback = value }
        end
      end
    end
    vim.ui.select(items, {
      format_item = function(item)
        if item.scope then
          return string.format("%s (%s)", item.builtin, item.scope)
        else
          return item.builtin
        end
      end,
      prompt = "Pickers",
    }, function(choice)
      if choice then choice.callback({ scope = choice.scope }) end
    end)
  end, { desc = "Select picker" })
end)

MiniDeps.later(function()
  require("mini.surround").setup({
    mappings = {
      add = "ys",
      delete = "ds",
      find = "",
      find_left = "",
      highlight = "",
      replace = "cs",
      update_n_lines = "",
      suffix_last = "",
      suffix_next = "",
    },
    n_lines = 100,
    search_method = "cover",
  })
  vim.keymap.del("x", "ys")
  vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
  vim.keymap.set("n", "yss", "ys_", { remap = true })
end)
