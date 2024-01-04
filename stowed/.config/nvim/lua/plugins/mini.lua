---@type LazySpec
local M = {
  "echasnovski/mini.nvim",
}

function M.config()
  require("mini.extra").setup {}

  require("mini.ai").setup {
    n_lines = 100,
    search_method = "cover",
    mappings = {
      around_next = "",
      inside_next = "",
      around_last = "",
      inside_last = "",
    },
    custom_textobjects = {
      f = false,
      B = MiniExtra.gen_ai_spec.buffer(),
      D = MiniExtra.gen_ai_spec.diagnostic(),
      I = MiniExtra.gen_ai_spec.indent(),
      L = MiniExtra.gen_ai_spec.line(),
      N = MiniExtra.gen_ai_spec.number(),
    },
  }

  require("mini.align").setup {}

  require("mini.basics").setup {
    options = { basic = false },
    mappings = { basic = false, option_toggle_prefix = "yo" },
    autocommands = { basic = true },
  }

  require("mini.bracketed").setup {
    comment = { suffix = "/", options = {} },
  }

  require("mini.bufremove").setup {}
  vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete buffer" })
  vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Wipeout buffer" })

  local miniclue = require "mini.clue"
  miniclue.setup {
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
      -- MiniSurround
      { mode = "n", keys = "s" },
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
  }

  require("mini.comment").setup {}

  local hipatterns = require "mini.hipatterns"
  hipatterns.setup {
    highlighters = {
      hex_color = hipatterns.gen_highlighter.hex_color {
        style = "#",
      },
    },
  }

  require("mini.notify").setup {
    lsp_progress = {
      duration_last = 2500,
      enable = true,
    },
  }
  vim.notify = MiniNotify.make_notify()

  require("mini.pairs").setup {}

  require("mini.pick").setup {
    mappings = { choose_marked = "<C-q>" },
  }
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set("n", "<leader>sb", MiniPick.builtin.buffers, { desc = "Pick from buffers" })
  vim.keymap.set("n", "<leader>sf", MiniPick.builtin.files, { desc = "Pick from files" })
  vim.keymap.set(
    "n",
    "<leader>sg",
    MiniPick.builtin.grep_live,
    { desc = "Pick from pattern matches with live feedback" }
  )
  vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "Pick from help tags" })
  vim.keymap.set("n", "<leader>sr", MiniPick.builtin.resume, { desc = "Resume latest picker" })

  vim.keymap.set("n", "<leader>gf", MiniExtra.pickers.git_files, { desc = "Git files picker" })
  vim.keymap.set("n", "<leader>gb", MiniExtra.pickers.git_branches, { desc = "Git branches picker" })
  vim.keymap.set("n", "<leader>gc", MiniExtra.pickers.git_commits, { desc = "Git commits picker" })
  vim.keymap.set("n", "<leader>gh", MiniExtra.pickers.git_hunks, { desc = "Git hunks picker" })

  vim.keymap.set("n", "<leader>sd", MiniExtra.pickers.diagnostic, { desc = "Built-in diagnostic picker" })
  vim.keymap.set("n", "<leader>/", function()
    MiniExtra.pickers.buf_lines { scope = "current" }
  end, { desc = "Buffer lines picker" })

  vim.keymap.set("n", "<leader>sq", function()
    MiniExtra.pickers.list { scope = "quickfix" }
  end, { desc = "Pick from quickfix list" })
  vim.keymap.set("n", "<leader>sl", function()
    MiniExtra.pickers.list { scope = "location" }
  end, { desc = "Pick from location list" })

  require("mini.surround").setup {
    n_lines = 100,
    search_method = "cover",
  }
end

return M
