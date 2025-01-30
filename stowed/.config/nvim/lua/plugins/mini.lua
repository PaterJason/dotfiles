MiniDeps.later(function() require("mini.extra").setup({}) end)

MiniDeps.later(
  function()
    require("mini.ai").setup({
      n_lines = 100,
      search_method = "cover",
      mappings = {
        around_next = "",
        inside_next = "",
        around_last = "",
        inside_last = "",
      },
      custom_textobjects = {
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

MiniDeps.later(function()
  require("mini.bufremove").setup({})
  vim.keymap.set("n", "<Leader>bd", MiniBufremove.delete, { desc = "Delete buffer" })
  vim.keymap.set("n", "<Leader>bw", MiniBufremove.wipeout, { desc = "Wipeout buffer" })
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
      -- LSP
      { mode = "n", keys = "cr" },
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
        width = "auto",
      },
    },
  })
end)

MiniDeps.later(function()
  require("mini.diff").setup({
    mappings = {
      apply = "<Leader>hs",
      reset = "<Leader>hx",
      textobject = "ih",
    },
  })
  vim.keymap.set(
    "n",
    "<Leader>ho",
    function() MiniDiff.toggle_overlay(0) end,
    { desc = "Toggle diff overlay" }
  )
end)

MiniDeps.later(function()
  require("mini.git").setup({})
  vim.keymap.set(
    { "n", "x" },
    "<Leader>g",
    function() MiniGit.show_at_cursor({}) end,
    { desc = "MiniGit show at cursor" }
  )

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "git", "diff", "gitcommit" },
    callback = function(_args)
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.MiniGit.diff_foldexpr()"
    end,
    group = "JPConfig",
    desc = "Git filetypes",
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniGitCommandSplit",
    callback = function(args)
      local subcmd = args.data.git_subcommand
      ---@type integer, integer
      local win_src, win_out = args.data.win_source, args.data.win_stdout
      local buf_src = vim.api.nvim_win_get_buf(win_src)
      local buf_out = vim.api.nvim_win_get_buf(win_out)
      local buf_data_src = MiniGit.get_buf_data(buf_src)
      if buf_data_src then vim.bo[buf_out].path = ".,," .. buf_data_src.root end

      vim.bo[args.buf].modifiable = false
      if subcmd == "help" then
        vim.bo[args.buf].filetype = "man"
      elseif subcmd == "blame" then
        vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
        vim.api.nvim_win_set_cursor(win_out, { vim.fn.line(".", win_src), 0 })
      end
    end,
    group = "JPConfig",
  })
end)

MiniDeps.later(function()
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      hex_color = hipatterns.gen_highlighter.hex_color({}),
    },
  })
end)

MiniDeps.now(function()
  require("mini.icons").setup({
    style = "glyph",
  })
  MiniIcons.mock_nvim_web_devicons()
end)

MiniDeps.later(function()
  require("mini.misc").setup({ make_global = {} })
  -- MiniMisc.setup_termbg_sync()
  vim.keymap.set("n", "<Leader>z", MiniMisc.zoom, { desc = "Zoom" })
end)

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
  vim.keymap.set("n", "<Leader>sb", MiniPick.builtin.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<Leader>sf", MiniPick.builtin.files, { desc = "Files" })
  vim.keymap.set("n", "<Leader>sg", MiniPick.builtin.grep_live, { desc = "Grep live" })
  vim.keymap.set("n", "<Leader>sh", MiniPick.builtin.help, { desc = "Help tags" })
  vim.keymap.set("n", "<Leader>sr", MiniPick.builtin.resume, { desc = "Resume" })

  vim.keymap.set(
    "n",
    "<Leader>sd",
    MiniExtra.pickers.diagnostic,
    { desc = "Built-in diagnostic picker" }
  )
  vim.keymap.set(
    "n",
    "<Leader>sl",
    function() MiniExtra.pickers.buf_lines({ scope = "current" }) end,
    { desc = "Buffer lines" }
  )
  vim.keymap.set(
    "n",
    "<Leader>sq",
    function() MiniExtra.pickers.list({ scope = "quickfix" }) end,
    { desc = "Quickfix list" }
  )

  vim.keymap.set("n", "<Leader><Leader>", function()
    local scopes = {
      buf_lines = { "current", "all" },
      diagnostic = { "current", "all" },
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
    local disabled = {
      "cli",
      "hipatterns",
      "treesitter",
      "visit_paths",
      "visit_labels",
    }
    local items = {}
    for key, value in vim.spairs(MiniPick.registry) do
      if vim.tbl_contains(disabled, key) then
        -- Do nothing
      elseif scopes[key] then
        for _, scope in ipairs(scopes[key]) do
          items[#items + 1] = { builtin = key, callback = value, scope = scope }
        end
      else
        items[#items + 1] = { builtin = key, callback = value }
      end
    end
    vim.ui.select(items, {
      format_item = function(item)
        if item.scope then
          return ("%s (%s)"):format(item.builtin, item.scope)
        else
          return item.builtin
        end
      end,
      prompt = "Pickers",
    }, function(item)
      if item then item.callback({ scope = item.scope }) end
    end)
  end, { desc = "Select picker" })
end)

MiniDeps.later(function() require("mini.splitjoin").setup({}) end)

MiniDeps.later(function()
  local function active()
    local git = MiniStatusline.section_git({ trunc_width = 40 })
    local diff = MiniStatusline.section_diff({ trunc_width = 75 })
    local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
    local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
    local filename = (
      vim.bo.filetype == "qf"
      and vim.w.quickfix_title
      and "%F " .. vim.w.quickfix_title
    ) or MiniStatusline.section_filename({ trunc_width = 140 })
    local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
    local location = MiniStatusline.section_location({ trunc_width = 75 })

    return MiniStatusline.combine_groups({
      { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
      "%<", -- Mark general truncate point
      { hl = "MiniStatuslineFilename", strings = { filename } },
      "%=", -- End left alignment
      { hl = "MiniStatuslineFileinfo", strings = { fileinfo, location } },
    })
  end

  local function inactive()
    return "%#MiniStatuslineInactive# "
      .. ((vim.bo.filetype == "qf" and vim.w.quickfix_title and "%F " .. vim.w.quickfix_title) or "%F")
      .. "%="
  end

  require("mini.statusline").setup({
    content = {
      active = active,
      inactive = inactive,
    },
  })
end)

MiniDeps.later(function()
  local gen_loader = require("mini.snippets").gen_loader
  require("mini.snippets").setup({
    snippets = {
      gen_loader.from_runtime("global.json"),
      gen_loader.from_lang(),
    },
  })
  local function select() MiniSnippets.expand({ match = false }) end
  vim.keymap.set("i", "<C-g><C-j>", select, { desc = "Expand all" })
  vim.keymap.set("n", "<Leader>ss", select, { desc = "Snippets" })

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniSnippetsSessionStart",
    callback = function()
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:n",
        once = true,
        callback = function()
          while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
          end
        end,
      })
    end,
  })

  for _, value in ipairs({
    "MiniSnippetsCurrent",
    "MiniSnippetsCurrentReplace",
    "MiniSnippetsFinal",
    "MiniSnippetsUnvisited",
    "MiniSnippetsVisited",
  }) do
    vim.cmd({
      cmd = "highlight",
      args = { value, "cterm=underdotted", "gui=underdotted" },
    })
  end
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
